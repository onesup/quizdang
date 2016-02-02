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

class Answer < ActiveRecord::Base
  # concerns
  include UpdownVoteable

  # constants
  TEXT_COUNT_MIN = 10

  # relations
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy

  # validations
  validates :text, presence: true
  validates :text, length: { minimum: TEXT_COUNT_MIN }, allow_blank: true, if: :text_changed?
  validates :user, presence: true
  validates :question, presence: true

  has_reputation :upvotes, source: :user, source_of: [
    { reputation: :votes },
    { reputation: :answer_upvotes, of: :user }
  ]
  has_reputation :downvotes, source: :user, source_of: [
    { reputation: :votes },
    { reputation: :answer_downvotes, of: :user }
  ]
  has_reputation :votes, source: [
    { reputation: :upvotes },
    { reputation: :downvotes }
  ]

  def owner?(current_user)
    user == current_user
  end
end
