# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  unique_id  :string(255)      not null
#  source     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ActiveRecord::Base
  # concerns
  include UpVoteable

  # relations
  has_many :questions
  has_many :hashtaggings, as: :hashtaggable, dependent: :destroy
  has_many :hashtags, through: :hashtaggings

  mount_uploader :image, ImageUploader
  has_reputation :votes, source: :user

  # scopes
  scope :desc_by_id, -> { order('id desc') }
end
