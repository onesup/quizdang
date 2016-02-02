# == Schema Information
#
# Table name: tickets
#
#  id            :integer          not null, primary key
#  details       :text(65535)      not null
#  email_address :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TicketsController < ApplicationController
  before_action :skip_authorization
  after_action :send_message_to_slack, only: :create

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.save
  end

  private

  def send_message_to_slack
    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: '#support',
      text: "#{@ticket.email_address}\n#{@ticket.details}"
    )
  end

  def ticket_params
    params[:ticket].permit(:details, :email_address)
  end
end
