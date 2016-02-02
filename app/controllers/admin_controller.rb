class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'admin'

  before_action :store_location

  def store_location
    if (!request.xhr? && request.get?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
end
