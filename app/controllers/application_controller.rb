class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_device_type
  before_action :passing_data_to_js
  after_action :verify_authorized
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_device_type
    return request.variant = :phone if browser.mobile?
    return request.variant = :tablet if browser.tablet?
    return request.variant = :desktop if !browser.mobile? && !browser.tablet?
  end

  def passing_data_to_js
    gon.isAuthenticated = user_signed_in?
  end

  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user ? current_user.id : 'guest'
    payload[:useragent] = request.user_agent
    # payload[:visit_id] = ahoy.visit_id # if you use Ahoy
  end

  def user_not_authorized
    # flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to request.referrer || root_path, status: 403
    # render json: { errors: 'not authorized', status: 403 }, status: 403
  end
end
