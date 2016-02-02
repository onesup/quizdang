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

require 'test_helper'

class BadgingTest < ActiveSupport::TestCase
  let(:badging) { FactoryGirl.create(:badging) }

  describe 'validations' do
    it 'badge must be presence' do
      badging.badge = nil
      badging.invalid?.must_equal true
      badging.errors[:badge].any?.must_equal true
    end

    it 'badging must be presence' do
      badging.badgeable = nil
      badging.invalid?.must_equal true
      badging.errors[:badgeable].any?.must_equal true
    end
  end
end
