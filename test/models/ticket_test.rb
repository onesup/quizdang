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

require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  let(:ticket) { FactoryGirl.create(:ticket) }

  describe 'validations' do
    it 'details must be presence' do
      ticket.details = nil
      ticket.invalid?.must_equal true
      ticket.errors[:details].any?.must_equal true
    end

    it 'email_address must be presence' do
      ticket.email_address = nil
      ticket.invalid?.must_equal true
      ticket.errors[:email_address].any?.must_equal true
    end

    it 'email_address should match valid email addresses' do
      valid_emails = ['test@example.com', 'jo@jo.co', 'f4$_m@you.com', 'testing.example@example.com.ua']
      valid_emails.each do |email|
        ticket.email_address = email
        ticket.valid?.must_equal true
      end

      non_valid_emails = ['rex', 'test@go,com', 'test user@example.com', 'test_user@example server.com', 'test_user@example.com.']
      non_valid_emails.each do |email|
        ticket.email_address = email
        ticket.invalid?.must_equal true
        ticket.errors[:email_address].any?.must_equal true
      end
    end
  end
end
