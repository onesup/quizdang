# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  unique_id  :string(255)      not null
#  source     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :photo do
    image 'test.png'
    sequence(:unique_id) { |n| "test.png#{n}" }
    source %w(pixabay unsplash).sample
  end
end
