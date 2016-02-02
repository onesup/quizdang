# == Schema Information
#
# Table name: options
#
#  id          :integer          not null, primary key
#  text        :string(255)      not null
#  correct     :boolean          default(FALSE), not null
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :option do
    text Faker::Lorem.sentence
    question
  end
end
