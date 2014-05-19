class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

protected
    def configure_devise_permitted_parameters
      registration_params = [:name, :email, :password, :password_confirmation]

      if params[:action] == 'update'
        devise_parameter_sanitizer.for(:account_update) { 
          |u| u.permit(registration_params << :current_password)
        }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) { 
          |u| u.permit(registration_params) 
        }
      end
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to root_path
    end

end
