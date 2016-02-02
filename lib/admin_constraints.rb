class AdminConstraints
  def matches?(req)
    current_user = req.env['warden'].user
    return false if current_user.blank?

    current_user.admin?
  end
end
