# == Schema Information
#
# Table name: badgings
#
#  id             :integer          not null, primary key
#  badge_id       :integer
#  badgeable_id   :integer
#  badgeable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Badging < ActiveRecord::Base
  # relations
  belongs_to :badge
  belongs_to :badgeable, polymorphic: true

  # validations
  validates :badge, presence: true
  validates :badgeable, presence: true

  def badgeable_partial_name
    return badgeable.class.to_s.underscore if badgeable.class == User
    'question'
  end
end
