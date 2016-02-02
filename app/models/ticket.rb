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

class Ticket < ActiveRecord::Base
  # constants
  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/

  # validations
  validates :details, presence: true
  validates :email_address, presence: true
  validates :email_address, format: { with: EMAIL_REGEX }, allow_blank: true, if: :email_address_changed?
end
