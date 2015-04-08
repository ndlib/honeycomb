class APIController < ApplicationController
  skip_before_action :redirect_to_sign_in

  before_action :set_access

  private

  def set_access
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
end
