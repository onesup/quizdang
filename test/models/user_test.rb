# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  username               :string(255)      default(""), not null
#  avatar                 :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  let(:user) { FactoryGirl.create(:user) }

  describe 'validations' do
    it 'email must not be presence' do
      user.email = nil
      user.invalid?.must_equal false
      user.errors[:email].any?.must_equal false
    end

    it 'email must be unique' do
      new_user = FactoryGirl.build(:user)
      new_user.email = user.email
      new_user.invalid?.must_equal true
      new_user.errors[:email].any?.must_equal true
    end

    it 'username must be presence' do
      user.username = nil
      user.invalid?.must_equal true
      user.errors[:username].any?.must_equal true
    end

    it 'username must be unique' do
      new_user = FactoryGirl.build(:user)
      new_user.username = user.username
      new_user.invalid?.must_equal true
      new_user.errors[:username].any?.must_equal true
    end

    it 'username must be unique case insensitivity' do
      new_user = FactoryGirl.build(:user)
      new_user.username = user.username.capitalize
      new_user.invalid?.must_equal true
      new_user.errors[:username].any?.must_equal true
    end
  end

  describe 'badge' do
    it 'add_badge' do
      badge = FactoryGirl.create(:badge, name: 'critic')
      user.add_badge('critic').badge.name.must_equal badge.name
      user.add_badge('critic').badge.name.must_equal badge.name
      user.badges.count.must_equal 1
    end
  end
end
