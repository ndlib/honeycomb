class ApplicationController < ActionController::Base
  
  before_filter :authenticate_user!, :except => [:catch_500, :catch_404]
  #before_filter :set_access_control_headers
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
