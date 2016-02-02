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

FactoryGirl.define do
  factory :ticket do
    details Faker::Lorem.sentence
    email_address Faker::Internet.email
  end
end
