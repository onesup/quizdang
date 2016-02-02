# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :text(65535)      not null
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#

FactoryGirl.define do
  factory :comment do
    text Faker::Lorem.sentence
    association :commentable, factory: :question
    user
  end
end
