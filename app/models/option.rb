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

class Option < ActiveRecord::Base
  # relations
  belongs_to :question, inverse_of: :options
  has_many :participants, dependent: :destroy

  # validations
  validates :text, presence: true
  validates :question, presence: true

  # callbacks
  before_validation { |option| option.text.try(:strip!) }

  def correct?
    correct
  end
end
