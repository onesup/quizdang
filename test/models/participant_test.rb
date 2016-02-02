# == Schema Information
#
# Table name: participants
#
#  id          :integer          not null, primary key
#  correct     :boolean
#  question_id :integer
#  option_id   :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  describe 'participant_ox' do
    let(:participant) { FactoryGirl.create(:participant) }

    describe 'validations' do
      it 'question must be presence' do
        participant.question = nil
        participant.invalid?.must_equal true
        participant.errors[:question].any?.must_equal true
      end

      it 'option must be presence' do
        participant.option = nil
        participant.invalid?.must_equal true
        participant.errors[:option].any?.must_equal true
      end

      it 'user must be presence' do
        participant.user = nil
        participant.invalid?.must_equal true
        participant.errors[:user].any?.must_equal true
      end
    end
  end

  describe 'participant_ox' do
    it 'correct' do
      participant = FactoryGirl.create(:participant_correct_ox)
      participant.reload.correct?.must_equal true
    end

    it 'incorrect' do
      participant = FactoryGirl.create(:participant_incorrect_ox)
      participant.reload.correct?.must_equal false
    end
  end

  describe 'participant_multiple_choice' do
    it 'correct' do
      participant = FactoryGirl.create(:participant_correct_multiple_choice)
      participant.reload.correct?.must_equal true
    end

    it 'incorrect' do
      participant = FactoryGirl.create(:participant_incorrect_multiple_choice)
      participant.reload.correct?.must_equal false
    end
  end
end
