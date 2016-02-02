# == Schema Information
#
# Table name: badges
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text(65535)      not null
#  slug        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kind        :integer          not null
#  level       :integer          not null
#  active      :boolean          default(FALSE), not null
#

class Badge < ActiveRecord::Base
  extend FriendlyId

  # relations
  has_many :badgings, dependent: :destroy

  # validations
  validates :name, presence: true
  validates :description, presence: true

  friendly_id :name, use: :slugged

  # enums
  enum kind: [:question, :answer, :participation, :moderation, :other]
  enum level: [:bronze, :silver, :gold]

  # scopes
  scope :actived, -> { where(active: true) }

  def self.by_count
    Badge.joins('LEFT JOIN badgings ON badgings.badge_id = badges.id')
      .select('badges.*, count(badge_id) as "badge_count"')
      .group(:name).order('id asc')
  end

  def questions
    Question.where(id: badgings.where(badgeable_type: 'Question').pluck(:badgeable_id))
  end

  def badge_count
    self[:badge_count] || badgings.count
  end

  def name_text
    I18n.t("badges.badge.#{slug}.name")
  end

  def description_text
    I18n.t("badges.badge.#{slug}.description")
  end
end
