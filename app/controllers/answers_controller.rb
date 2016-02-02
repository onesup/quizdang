# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  text        :text(65535)      not null
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:edit, :update, :destroy, :vote]

  def edit
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    authorize @answer
    @answer.update(answer_params)
  end

  def destroy
    @answer = Answer.find(params[:id])
    authorize @answer
    @answer.destroy!
  end

  def vote
    @answer = Answer.find(params[:id])
    authorize @answer
    unless @answer.owner?(current_user)
      if params[:type] == 'up'
        @answer.delete_evaluation(:downvotes, current_user) if @answer.downvoted_by?(current_user)
        @answer.add_or_delete_evaluation(:upvotes, 1, current_user)
        current_user.add_badge('supporter')
      else
        @answer.delete_evaluation(:upvotes, current_user) if @answer.upvoted_by?(current_user)
        @answer.add_or_delete_evaluation(:downvotes, -1, current_user)
        current_user.add_badge('critic')
        current_user.touch
      end
      @answer.touch
    end
  end

  private

  def answer_params
    params[:answer].permit('text')
  end
end
