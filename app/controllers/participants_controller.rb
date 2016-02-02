# == Schema Information
#
# Table name: participants
#
#  id          :integer          not null, primary key
#  correct     :boolean
#  question_id :integer
#  option_id   :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_participant, only: :create
  after_action :verify_authorized, only: :show

  def show
    @participant = Participant.find(params[:id])
    authorize @participant
    @question = @participant.question
  end

  def create
    unless @question.owner?(current_user)
      @participant = @question.participants.new(participant_params)
      @participant.user = current_user
      if @participant.save
        @question.add_evaluation(:participants, 1, current_user)
        if @participant.correct?
          current_user.add_evaluation(:participant_points, 1, @question)
        end
      end
    end
  end

  private

  def verify_participant
    @question = Question.find(params[:question_id])
    render 'participant' if @question.participant_by?(current_user)
  end

  def participant_params
    params[:participant].permit(:option_id, :text)
  end
end
