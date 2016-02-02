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

require 'test_helper'

class SubdangTest < ActiveSupport::TestCase
  let(:subdang) { FactoryGirl.create(:subdang) }

  describe 'validations' do
    it 'name must be presence' do
      subdang.name = nil
      subdang.invalid?.must_equal true
      subdang.errors[:name].any?.must_equal true
    end

    it 'name must be unique' do
      new_subdang = FactoryGirl.build(:subdang)
      new_subdang.name = subdang.name
      new_subdang.invalid?.must_equal true
      new_subdang.errors[:name].any?.must_equal true
    end
  end

  describe 'tree' do
    it 'create children' do
      child = subdang.children.create(name: 'child')
      child.parent.must_equal subdang
    end
  end
end
