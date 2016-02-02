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

require 'test_helper'

class BadgeTest < ActiveSupport::TestCase
  let(:badge) { FactoryGirl.create(:badge) }

  describe 'validations' do
    it 'name must be presence' do
      badge.name = nil
      badge.invalid?.must_equal true
      badge.errors[:name].any?.must_equal true
    end

    it 'description must be presence' do
      badge.description = nil
      badge.invalid?.must_equal true
      badge.errors[:description].any?.must_equal true
    end

    it 'slug must be equal to name' do
      badge.slug.must_equal badge.name.parameterize
    end
  end
end
