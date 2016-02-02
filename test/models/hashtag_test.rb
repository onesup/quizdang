# == Schema Information
#
# Table name: hashtags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#  user_id    :integer
#

require 'test_helper'

class HashtagTest < ActiveSupport::TestCase
  let(:hashtag) { FactoryGirl.create(:hashtag) }

  describe 'validations' do
    it 'name must be presence' do
      hashtag.name = nil
      hashtag.invalid?.must_equal true
      hashtag.errors[:name].any?.must_equal true
    end

    it 'name must be unique' do
      new_hashtag = FactoryGirl.build(:hashtag)
      new_hashtag.name = hashtag.name
      new_hashtag.invalid?.must_equal true
      new_hashtag.errors[:name].any?.must_equal true
    end

    it 'name must be unique case insensitivity' do
      new_hashtag = FactoryGirl.build(:hashtag)
      new_hashtag.name = hashtag.name.capitalize
      new_hashtag.invalid?.must_equal true
      new_hashtag.errors[:name].any?.must_equal true
    end
  end

  describe 'tree' do
    it 'create children' do
      child = hashtag.children.create(name: 'child')
      child.parent.must_equal hashtag
    end
  end
end
