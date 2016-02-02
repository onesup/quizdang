module ApplicationHelper
  def resource_name
    :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Y:  Year (4 characters)
  # Q:  Quarter (1 character, 1 – 4)
  # M:  Month (2 characters, 01-12)
  # WY: Week Year (4 characters)
  # WM: Week Month (2 characters, 01-12)
  # WD: Week Day (2 characters, 01-31)
  # D:  Day (2 characters, 01-31)
  # H:  Hour (2 characters, 00-23)
  def ga_custom_cohort_variable(timestamp)
    y = timestamp.strftime('%Y')
    q = ((timestamp.month - 1) / 3) + 1
    m = timestamp.strftime('%m')
    d = timestamp.strftime('%d')
    h = timestamp.strftime('%H')

    wy = timestamp.beginning_of_week.strftime('%Y')
    wm = timestamp.beginning_of_week.strftime('%m')
    wd = timestamp.beginning_of_week.strftime('%d')

    "Y:#{y};Q:#{q};M:#{m};WY:#{wy};WM:#{wm};WD:#{wd};D:#{d};H:#{h}"
  end
end
