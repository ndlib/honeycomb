class ApplicationController < ActionController::Base
  
  before_action :redirect_to_sign_in, unless: :user_signed_in?
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    def redirect_to_sign_in
      redirect_to new_user_session_path
    end
end
