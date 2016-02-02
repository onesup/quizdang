# == Schema Information
#
# Table name: badgings
#
#  id             :integer          not null, primary key
#  badge_id       :integer
#  badgeable_id   :integer
#  badgeable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :badging do
    badge
    association :badgeable, factory: :question
  end
end
