require 'error_helper'
class ApplicationController < ActionController::Base
  include ErrorHelper

  before_action :redirect_to_sign_in, unless: :user_signed_in?, :except => [:catch_500, :catch_404]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  unless Rails.configuration.consider_all_requests_local
    rescue_from ActionController::RoutingError, :with => :catch_404
    rescue_from ActionController::UnknownController, :with => :catch_404
    rescue_from AbstractController::ActionNotFound, :with => :catch_404
    rescue_from ActiveRecord::RecordNotFound, :with => :catch_404
    rescue_from Exception, :with => :catch_500
  end

  protected

    def permission
      @permission ||= SitePermission.new(current_user, self)
    end

    def check_admin_permission!
      if !permission.user_is_administrator?
        raise_404("User not an admin")
      end
    end


    def check_admin_or_admin_masquerading_permission!
      if !(permission.user_is_admin_in_masquerade? || permission.user_is_administrator?)
        raise_404("User not a admin or an admin in masquerade")
      end
    end


    def raise_404(message = "Not Found")
      raise ActionController::RoutingError.new(message)
    end
    private

    def redirect_to_sign_in
      redirect_to new_user_session_path
    end

end
