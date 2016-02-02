class UserPolicy < ApplicationPolicy
  def update?
    (@record.id == @user.id) || @user.admin?
  end
end
