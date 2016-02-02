class QuestionPolicy < ApplicationPolicy
  def vote?
    return true unless record.voted_by?(user)
    return true if record.voted_by?(user)
  end

  def favorite?
    return true unless record.favorited_by?(user)
    return true if record.favorited_by?(user)
  end
end
