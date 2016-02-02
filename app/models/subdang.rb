# == Schema Information
#
# Table name: subdangs
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  featured_image :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#

class Subdang < ActiveRecord::Base
  # constants
  NAME_LENGTH_IN = 2..20
  NAME_REGEX = /\A[\p{L}\d]+\z/

  # relations
  belongs_to :user
  has_many :questions

  # validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, allow_blank: true, if: :name_changed?
  validates :name, format: { with: NAME_REGEX }, allow_blank: true, if: :name_changed?
  validates :name, length: { in: NAME_LENGTH_IN }, allow_blank: true, if: :name_changed?

  # callbacks
  before_validation :normalize_name, if: Proc.new { name.present? && name_changed? }

  mount_uploader :featured_image, ImageUploader
  has_closure_tree

  def normalize_name
    self.name = name.gsub(/[^\p{L}\d]/, '')
  end
end
