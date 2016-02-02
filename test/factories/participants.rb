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

FactoryGirl.define do
  factory :participant do
    association :question, factory: :question_ox
    option
    user

    factory :participant_correct_ox do
      association :question, factory: :question_ox

      before(:create) do |participant|
        participant.option = participant.question.options.where(correct: true).first
      end
    end

    factory :participant_incorrect_ox do
      association :question, factory: :question_ox

      before(:create) do |participant|
        participant.option = participant.question.options.where(correct: false).first
      end
    end

    factory :participant_correct_multiple_choice do
      association :question, factory: :question_multiple_choice

      before(:create) do |participant|
        participant.option = participant.question.options.where(correct: true).first
      end
    end

    factory :participant_incorrect_multiple_choice do
      association :question, factory: :question_multiple_choice

      before(:create) do |participant|
        participant.option = participant.question.options.where(correct: false).first
      end
    end
  end
end
