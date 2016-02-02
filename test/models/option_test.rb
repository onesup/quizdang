# == Schema Information
#
# Table name: options
#
#  id          :integer          not null, primary key
#  text        :string(255)      not null
#  correct     :boolean          default(FALSE), not null
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  let(:option) { FactoryGirl.create(:option) }

  describe 'validations' do
    it 'text must be presence' do
      option.text = nil
      option.invalid?.must_equal true
      option.errors[:text].any?.must_equal true
    end

    it 'question must be presence' do
      option.question = nil
      option.invalid?.must_equal true
      option.errors[:question].any?.must_equal true
    end
  end
end
