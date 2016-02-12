# == Schema Information
#
# Table name: hashtags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#

FactoryGirl.define do
  factory :hashtag do
    name Faker::Lorem.name
    user
  end
end
