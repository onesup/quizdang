# == Schema Information
#
# Table name: hashtaggings
#
#  id                :integer          not null, primary key
#  hashtag_id        :integer
#  hashtaggable_id   :integer
#  hashtaggable_type :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Hashtagging < ActiveRecord::Base
  # relations
  belongs_to :hashtag
  belongs_to :hashtaggable, polymorphic: true

  # validations
  validates :hashtag, presence: true
  validates :hashtaggable, presence: true

  def hashtaggable_partial_name
    return hashtaggable.class.to_s.underscore
  end
end
