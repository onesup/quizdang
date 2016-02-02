class Admin::BadgesController < AdminController
  def index
    @badges = Badge.all
  end
end
