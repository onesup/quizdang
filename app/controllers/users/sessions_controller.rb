class Users::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters
  skip_after_action :verify_authorized

  def create
    if request.xhr?
      resource = warden.authenticate(scope: resource_name)
      if resource.present?
        sign_in(resource_name, resource)
      end
    else
      super
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << [:username]
  end
end
