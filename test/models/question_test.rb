# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  question_type :string(255)      not null
#  text          :string(255)      not null
#  status        :integer          default(0), not null
#  views_count   :integer          default(1), not null
#  quiz_id       :integer
#  photo_id      :integer
#  user_id       :integer
#  subdang_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  let(:question) { FactoryGirl.create(:question) }

  describe 'validations' do
    it 'text must be presence' do
      question.text = nil
      question.invalid?.must_equal true
      question.errors[:text].any?.must_equal true
    end

    it 'text minimum' do
      question.text = '*' * ((Question::TEXT_COUNT_IN).first - 1)
      question.invalid?.must_equal true
      question.errors[:text].any?.must_equal true
    end

    it 'text maximum' do
      question.text = '*' * ((Question::TEXT_COUNT_IN).last + 1)
      question.invalid?.must_equal true
      question.errors[:text].any?.must_equal true
    end

    it 'question_type must be presence' do
      question.question_type = nil
      question.invalid?.must_equal true
      question.errors[:question_type].any?.must_equal true
    end

    it 'question_type must be inclusion' do
      question.question_type = 'foobar'
      question.invalid?.must_equal true
      question.errors[:question_type].any?.must_equal true
    end

    it 'photo must be presence' do
      question.photo = nil
      question.invalid?.must_equal true
      question.errors[:photo].any?.must_equal true
    end

    # it 'subdang must be presence' do
      # question.subdang = nil
      # question.invalid?.must_equal true
      # question.errors[:subdang].any?.must_equal true
    # end

    it 'user must be presence' do
      question.user = nil
      question.invalid?.must_equal true
      question.errors[:user].any?.must_equal true
    end
  end

  describe 'MultipleChoice' do
    let(:question) { FactoryGirl.create(:question_multiple_choice) }

    it 'must be valid' do
      question.valid?.must_equal true
    end

    it 'must be invalid' do
      question.options.build
      question.options.build
      question.options.build
      question.invalid?.must_equal true
      question.errors[:options].any?.must_equal true
    end
  end

  describe 'Ox' do
    let(:question) { FactoryGirl.create(:question_ox) }

    describe 'validations' do
      it 'must be valid' do
        question.valid?.must_equal true
      end

      it 'must be invalid' do
        question.options.build
        question.invalid?.must_equal true
        question.errors[:options].any?.must_equal true
      end
    end
  end
end
