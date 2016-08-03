class APIController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :redirect_to_sign_in

  before_action :set_access

  protected

  # Checks if a user can edit the given collection. If they cannot
  # then it will handle rendering a forbidden response.
  # Returns true if the response was rendered
  def rendered_forbidden?(collection)
    can_edit = user_can_edit?(collection)
    unless can_edit
      @errors = { 403 => "User does not have permission to edit this collection." }
      render json: @errors, status: :forbidden
    end
    !can_edit
  end

  private

  def set_access
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
