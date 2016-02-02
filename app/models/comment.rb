# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :text(65535)      not null
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#

class Comment < ActiveRecord::Base
  # concerns
  include UpVoteable

  # relations
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # validations
  validates :text, presence: true
  validates :commentable, presence: true
  validates :user, presence: true

  has_closure_tree
  has_reputation :votes, source: :user

  def owner?(current_user)
    user == current_user
  end
end
