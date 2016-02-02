# == Schema Information
#
# Table name: badges
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text(65535)      not null
#  slug        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kind        :integer          not null
#  level       :integer          not null
#  active      :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :badge do
    name Faker::Lorem.name
    description Faker::Lorem.sentence
    kind 'question'
    level 'bronze'
  end
end
