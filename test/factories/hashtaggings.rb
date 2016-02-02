# == Schema Information
#
# Table name: hashtaggings
#
#  id                :integer          not null, primary key
#  hashtag_id        :integer
#  hashtaggable_id   :integer
#  hashtaggable_type :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :hashtagging do
    hashtag
    association :hashtaggable, factory: :question
  end
end
