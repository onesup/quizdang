class CommentPolicy < ApplicationPolicy
  def vote?
    return true unless record.voted_by?(user)
    return true if record.voted_by?(user)
  end
end
