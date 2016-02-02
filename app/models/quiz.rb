# == Schema Information
#
# Table name: quizzes
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  description    :text(65535)
#  featured_image :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

class Quiz < ActiveRecord::Base
  # relations
  belongs_to :user
  has_many :questions

  # validations
  validates :title, presence: true
  validates :user, presence: true

  # callbacks
  before_validation { |quiz| quiz.title.try(:strip!) }

  # uploaders
  mount_uploader :featured_image, ImageUploader
end
