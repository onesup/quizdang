class Admin::ParticipantsController < AdminController
  def index
    @participants = Participant.includes(:question, :option).page(params[:page]).per(100)
  end

  def show
    @participant = Participant.find(params[:id])
  end
end
