# == Schema Information
#
# Table name: subdangs
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  featured_image :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#

FactoryGirl.define do
  factory :subdang do
    sequence(:name) { |n| "#{Faker::Lorem.name}#{n}" }
    user
  end
end
