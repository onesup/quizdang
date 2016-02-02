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

FactoryGirl.define do
  factory :answer do
    text Faker::Lorem.sentence
    user
    question
  end
end
