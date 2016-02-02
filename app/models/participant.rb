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

class Participant < ActiveRecord::Base
  # relations
  belongs_to :question
  belongs_to :option
  belongs_to :user

  # validations
  validates :question, presence: true
  validates :option, presence: true
  validates :user, presence: true

  # callbacks
  after_create :mark_correct!

  def correct?
    correct
  end

  def mark_correct!
    mark_correct
    save!
  end

  def user_participant_text
    option.text
  end

  def correct_participant_text
    question.correct_option.text
  end

  private

  def mark_correct
    self.correct = option.try(:correct)
  end
end
