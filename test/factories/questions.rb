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

FactoryGirl.define do
  factory :question do
    text Faker::Lorem.sentence
    photo
    quiz
    subdang
    user
    question_type Question::TYPE.sample

    before(:create) do |question|
      question.photo = FactoryGirl.create(:photo)
    end

    factory :question_ox do
      question_type 'Ox'
      transient do
        options_count 1
      end

      after(:create) do |question, evaluator|
        # create_list(:option, evaluator.options_count, question: question)
        FactoryGirl.create(:option, question: question, correct: true)
        FactoryGirl.create(:option, question: question, correct: false)
      end
    end

    factory :question_multiple_choice do
      question_type 'MultipleChoice'
      transient do
        options_count 1
      end

      after(:create) do |question, evaluator|
        FactoryGirl.create(:option, question: question, correct: true)
        FactoryGirl.create(:option, question: question, correct: false)
      end
    end
  end
end
