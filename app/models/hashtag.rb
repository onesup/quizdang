# == Schema Information
#
# Table name: hashtags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#  user_id    :integer
#

class Hashtag < ActiveRecord::Base
  # constants
  NAME_LENGTH_IN = 1..20
  NAME_REGEX = /\A[\p{L}\d]+\z/

  # relations
  belongs_to :user
  has_many :hashtaggings, dependent: :destroy

  # validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, allow_blank: true, if: :name_changed?
  validates :name, format: { with: NAME_REGEX }, allow_blank: true, if: :name_changed?
  validates :name, length: { in: NAME_LENGTH_IN }, allow_blank: true, if: :name_changed?

  # callbacks
  before_validation :normalize_name, if: Proc.new { name.present? && name_changed? }

  has_closure_tree

  def self.by_count
    Hashtag.joins('LEFT JOIN hashtaggings ON hashtaggings.hashtag_id = hashtags.id')
      .select('hashtags.*, count(hashtag_id) as "hashtag_count"')
      .group(:name).order('hashtag_count desc, id asc')
  end

  def questions
    ids = hashtaggings.where(hashtaggable_type: 'Question').pluck(:hashtaggable_id)
    Question.where(id: ids)
  end

  def photos
    ids = hashtaggings.where(hashtaggable_type: 'Photo').pluck(:hashtaggable_id)
    Photo.where(id: ids)
  end

  def normalize_name
    self.name = name.gsub(/[^\p{L}\d]/, '')
  end
end
