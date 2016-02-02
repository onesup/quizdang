# == Schema Information
#
# Table name: quizzes
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  description    :text(65535)
#  featured_image :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  let(:quiz) { FactoryGirl.create(:quiz) }

  describe 'validations' do
    it 'title must be presence' do
      quiz.title = nil
      quiz.invalid?.must_equal true
      quiz.errors[:title].any?.must_equal true
    end

    it 'user must be presence' do
      quiz.user = nil
      quiz.invalid?.must_equal true
      quiz.errors[:user].any?.must_equal true
    end
  end
end
