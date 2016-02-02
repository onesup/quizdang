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

class Question < ActiveRecord::Base
  # concerns
  include UpdownVoteable

  # constants
  TYPE = %w(Ox MultipleChoice)
  TEXT_COUNT_IN = 3..150

  # relations
  belongs_to :quiz
  belongs_to :photo
  belongs_to :subdang
  belongs_to :user
  has_many :options, dependent: :destroy, inverse_of: :question # fix nested bug
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :badgings, as: :badgeable, dependent: :destroy
  has_many :badges, through: :badgings
  has_many :hashtaggings, as: :hashtaggable, dependent: :destroy
  has_many :hashtags, through: :hashtaggings
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # validations
  validates :text, presence: true
  validates :text, length: { in: TEXT_COUNT_IN }, allow_blank: true, if: :text_changed?
  validates :question_type, presence: true
  validates :question_type, inclusion: { in: TYPE }, allow_blank: true, if: :question_type_changed?
  validates :photo, presence: true
  # validates :subdang, presence: true
  validates :user, presence: true
  validate :type_specific_validation
  validate :check_option_correct

  # callbacks
  before_save { |question| question.text.try(:strip!) }

  # specifying index, type and back-reference for updating after question save or destroy
  # update_index('questions#question') { self }

  has_reputation :favorites, source: :user, source_of: [
    { reputation: :question_score },
  ]
  has_reputation :participants, source: :user, source_of: [
    { reputation: :question_score },
  ]
  has_reputation :upvotes, source: :user, source_of: [
    { reputation: :votes },
    { reputation: :question_upvotes, of: :user }
  ]
  has_reputation :downvotes, source: :user, source_of: [
    { reputation: :votes },
    { reputation: :question_downvotes, of: :user }
  ]
  has_reputation :votes, source: [
    { reputation: :upvotes },
    { reputation: :downvotes }
  ]
  has_reputation :question_score, source: [
    { reputation: :votes },
    { reputation: :favorites },
    { reputation: :participants }
  ]

  enum status: [:inactive, :active, :archived]

  # nested_attributes
  accepts_nested_attributes_for :options

  # scopes
  scope :desc_by_id, -> { order('id desc') }
  scope :desc_by_views, -> { order('views_count desc') }
  scope :random_order, -> { order('RAND()') }
  # FIXME: OPTIMIZE TODO https://github.com/twitter/activerecord-reputation-system/issues/62
  scope :desc_by_question_score, -> { reorder('question_score desc').find_with_reputation(:question_score, :all) }

  # OPTIMIZE: find_with_reputation || eager_load || reputation_for
  def participants_value
    self[:participants] || participants_reputation.try(:value) || reputation_for(:participants)
  end

  def correct_option
    options.find_by(correct: true)
  end

  def ox?
    question_type == 'Ox'
  end

  def multiple_choice?
    question_type == 'MultipleChoice'
  end

  def self.random
    order('RAND()').first
  end

  def owner?(user)
    self.user == user
  end

  def favorited_by?(user)
    return false unless user
    has_evaluation?(:favorites, user)
  end

  def participant_by(user)
    participants.find_by(user: user)
  end

  def participant_by?(user)
    participant_by(user).present?
  end

  private

  def type
    case question_type
    when 'Ox'
      Question::Ox.new
    when 'MultipleChoice'
      Question::MultipleChoice.new
    else
      fail 'Unknown question type'
    end
  end

  def type_specific_validation
    type.validate_options(self) if options.size > 0
  end

  def option_correct_valid?
    options.map(&:correct).select { |item| item == true }.count == 1
  end

  def check_option_correct
    return unless type.need_validate_option_correct?(self)
    errors.add(:options, :options_invalid) unless option_correct_valid?
  end

  # OPTIMIZE: Eager Loading the Reputation Values for an Array
  # https://github.com/twitter/activerecord-reputation-system/issues/27
  # has_one :votes_reputation, -> { where(reputation_name: 'votes') }, class_name: 'ReputationSystem::Reputation', as: :target
  def participants_reputation
    reputations.find { |r| r.reputation_name == 'participants' }
  end
end
