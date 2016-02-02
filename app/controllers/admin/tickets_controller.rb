class Admin::TicketsController < AdminController
  def index
    @tickets = Ticket.all.page(params[:page]).per(100)
  end

  def show
    @ticket = Ticket.find(params[:id])
  end
end
