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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  let(:comment) { FactoryGirl.create(:comment) }

  describe 'validations' do
    it 'text must be presence' do
      comment.text = nil
      comment.invalid?.must_equal true
      comment.errors[:text].any?.must_equal true
    end

    it 'commentable must be presence' do
      comment.commentable = nil
      comment.invalid?.must_equal true
      comment.errors[:commentable].any?.must_equal true
    end

    it 'user must be presence' do
      comment.user = nil
      comment.invalid?.must_equal true
      comment.errors[:user].any?.must_equal true
    end
  end

  describe 'tree' do
    it 'create children' do
      child = comment.children.create(text: 'child')
      child.parent.must_equal comment
    end
  end
end
