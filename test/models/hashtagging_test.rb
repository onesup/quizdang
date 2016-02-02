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

require 'test_helper'

class HashtaggingTest < ActiveSupport::TestCase
  let(:hashtagging) { FactoryGirl.create(:hashtagging) }

  describe 'validations' do
    it 'hashtag must be presence' do
      hashtagging.hashtag = nil
      hashtagging.invalid?.must_equal true
      hashtagging.errors[:hashtag].any?.must_equal true
    end

    it 'hashtagging must be presence' do
      hashtagging.hashtaggable = nil
      hashtagging.invalid?.must_equal true
      hashtagging.errors[:hashtaggable].any?.must_equal true
    end

    it 'hashtag and hashtaggable must be unique' do
      proc {
        FactoryGirl.create(:hashtagging,
                           hashtag: hashtagging.hashtag,
                           hashtaggable: hashtagging.hashtaggable)
      }.must_raise ActiveRecord::RecordNotUnique
    end
  end
end
