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

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  let(:photo) { FactoryGirl.create(:photo) }

  it 'create_photo' do
    photo.valid?
  end

  it 'hashtagging' do
    hashtag = FactoryGirl.create(:hashtag)
    photo.hashtaggings.create!(hashtag: hashtag)
  end
end
