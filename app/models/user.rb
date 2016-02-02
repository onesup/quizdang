# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  username               :string(255)      default(""), not null
#  avatar                 :string(255)
#

class User < ActiveRecord::Base
  # concerns
  include Authenticable

  # constants
  USERNAME_LENGTH_IN = 3..20
  USERNAME_REGEX = /\A[a-zA-Z0-9\-._]+\z/

  # relations
  has_many :quizzes
  has_many :questions
  has_many :answers
  has_many :participants, dependent: :destroy
  has_many :participant_questions, through: :participants, source: 'question'
  has_many :badgings, as: :badgeable, dependent: :destroy
  has_many :badges, through: :badgings
  has_many :comments
  has_many :hashtags
  has_many :subdangs

  # validations
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }, allow_blank: true, if: :username_changed?
  validates :username, format: { with: USERNAME_REGEX }, allow_blank: true, if: :username_changed?
  validates :username, length: { in: USERNAME_LENGTH_IN }, allow_blank: true, if: :username_changed?

  # callbacks
  after_create :default_karma_value

  # role
  rolify

  # uploaders
  mount_uploader :avatar, AvatarUploader

  # reputations
  # participation karma
  # negative
  has_reputation :voted_down_question, source: :question, source_of: { reputation: :karma }
  has_reputation :participant_points, source: :question, source_of: { reputation: :karma }

  # quality karma
  has_reputation :question_upvotes, source: { reputation: :upvotes, of: :questions }, source_of: [
    { reputation: :karma },
    { reputation: :question_votes }
  ]
  # negative
  has_reputation :question_downvotes, source: { reputation: :downvotes, of: :questions }, source_of: [
    { reputation: :karma },
    { reputation: :question_votes }
  ]
  has_reputation :question_votes, source: [
    { reputation: :question_upvotes },
    { reputation: :question_downvotes }
  ]
  has_reputation :answer_upvotes, source: { reputation: :upvotes, of: :answers }, source_of: [
    { reputation: :karma },
    { reputation: :answer_votes }
  ]
  # negative
  has_reputation :answer_downvotes, source: { reputation: :downvotes, of: :answers }, source_of: [
    { reputation: :karma },
    { reputation: :answer_votes }
  ]
  has_reputation :answer_votes, source: [
    { reputation: :answer_upvotes },
    { reputation: :answer_downvotes }
  ]

  # robust karma
  has_reputation :karma, source: [
    { reputation: :participant_points },
    { reputation: :voted_down_question },
    { reputation: :question_downvotes, weight: 2 },
    { reputation: :question_upvotes, weight: 10 },
    { reputation: :answer_downvotes, weight: 2 },
    { reputation: :answer_upvotes, weight: 5 }
  ]

  # scopes
  scope :admins, -> { with_role(:admin) }
  scope :not_admins, -> { where.not(id: User.with_role(:admin).pluck(:id)) }

  # FIXME: OPTIMIZE TODO https://github.com/twitter/activerecord-reputation-system/issues/62
  def self.by_karma
    reorder('karma desc').find_with_reputation(:karma, :all)
    # select("users.*, coalesce(rs_reputations.value, 0) as karma").
    # joins("LEFT JOIN rs_reputations ON users.id = rs_reputations.target_id AND rs_reputations.target_type = 'User' AND rs_reputations.reputation_name = 'karma' AND rs_reputations.active = 1").
    # order("karma desc")
  end

  def karma
    self[:karma] || reputation_for(:karma)
  end

  def name
    self[:name] || username
  end

  def admin?
    has_role?(:admin)
  end

  def self.create_with_identicon!(hash)
    user = new(hash)
    user.avatar = user.generate_identicon
    user.save!
    user
  end

  def generate_identicon
    # blob = RubyIdenticon.create(email, background_color: 0xecececec)
    blob = RubyIdenticon.create(username)
    CarrierwaveStringIO.new("#{Digest::MD5.hexdigest(username)}.png", blob)
  end

  def add_badge(badge_name)
    badge = Badge.friendly.find(badge_name)
    badgings.where(badge: badge).first_or_create!
  end

  def email_required?
    false
  end

  def remember_me
    true
    # this case you'll get remember_me enabled by default, otherwise, you'll get a user choise
    # super.nil? ? true : super
  end

  private

  def default_karma_value
    reputation_for(:karma)
    reputations.find_by(reputation_name: 'karma').update(value: 1.0)
  end
end
