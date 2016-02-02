# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  question_type :string(255)      not null
#  text          :string(255)      not null
#  status        :integer          default(0), not null
#  views_count   :integer          default(1), not null
#  quiz_id       :integer
#  photo_id      :integer
#  user_id       :integer
#  subdang_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :guide, :embed]
  before_action :verify_participant, only: :show
  after_action :verify_authorized, only: [:edit, :update, :destroy, :vote, :favorite]
  after_action :track_page_view, only: :show
  after_action :allow_iframe, only: :embed

  def index
    if params[:sort] == 'newly'
      @questions = Question.all.desc_by_id.includes(:user, :photo, :reputations).page(params[:page])
    elsif params[:sort] == 'votes'
      @questions = Question.desc_by_votes.includes(:user, :photo, :reputations).page(params[:page])
    elsif params[:sort] == 'hot'
      @questions = Question.all.desc_by_question_score.includes(:user, :photo, :reputations).page(params[:page])
    else
      @questions = Question.all.desc_by_id.includes(:user, :photo, :reputations).page(params[:page])
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
    @question.photo = Photo.all.sample
    @question.question_type = params[:type]
    if @question.ox?
      @question.options.build(text: '그렇다', correct: true)
      @question.options.build(text: '아니다', correct: true)
    elsif @question.multiple_choice?
      @question.options.build(correct: true)
      @question.options.build(correct: true)
      @question.options.build(correct: true)
    end
  end

  def edit
    @question = Question.find(params[:id])
    authorize @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @question.save
  end

  def update
    @question = Question.find(params[:id])
    authorize @question
    @question.update(question_params)
  end

  def destroy
    @question = Question.find(params[:id])
    authorize @question
    @question.destroy!
  end

  def embed
    @question = Question.find(params[:id])
    render 'embed', layout: 'embed_layout'
  end

  def vote
    @question = Question.find(params[:id])
    authorize @question
    unless @question.owner?(current_user)
      if params[:type] == 'up'
        @question.delete_evaluation(:downvotes, current_user) if @question.downvoted_by?(current_user)
        @question.add_or_delete_evaluation(:upvotes, 1, current_user)
        current_user.add_badge('supporter')
      else
        @question.delete_evaluation(:upvotes, current_user) if @question.upvoted_by?(current_user)
        @question.add_or_delete_evaluation(:downvotes, -1, current_user)
        current_user.add_badge('critic')
        current_user.add_or_delete_evaluation(:voted_down_question, -1, @question)
        current_user.touch
      end
      @question.touch
    end
  end

  def favorite
    @question = Question.find(params[:id])
    authorize @question
    unless @question.owner?(current_user)
      @question.add_or_delete_evaluation(:favorites, 1, current_user)
      @question.touch
    end
  end

  def random
    @question = Question.random
    redirect_to question_path(@question)
  end

  private

  def question_params
    params[:question].permit(
      :question_type, :text, :subdang_id, :quiz_id, :photo_id,
      options_attributes: [:id, :text, :correct]
    )
  end

  def verify_participant
    @question = Question.find(params[:id])
    redirect_to @question.participant_by(current_user) if @question.participant_by?(current_user)
  end

  def track_page_view
    logger.debug(fingerprint_cookie_value)
    RedisClient.redis.sadd 'question:tracking', @question.id
    RedisClient.redis.sadd "question:#{@question.id}:uniques", fingerprint_cookie_value
  end

  def fingerprint_cookie_value
    cookie_key = Digest::MD5.hexdigest('browser_fingerprint')
    cookies[cookie_key]
  end

  def allow_iframe
    response.headers.delete 'X-Frame-Options'
  end
end
