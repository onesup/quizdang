# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  text        :text(65535)      not null
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  let(:answer) { FactoryGirl.create(:answer) }

  describe 'validations' do
    it 'text must be presence' do
      answer.text = nil
      answer.invalid?.must_equal true
      answer.errors[:text].any?.must_equal true
    end

    it 'text minimum' do
      answer.text = '*' * (Answer::TEXT_COUNT_MIN - 1)
      answer.invalid?.must_equal true
      answer.errors[:text].any?.must_equal true
    end
  end
end
