class ApiController < ApplicationController
  skip_before_filter :redirect_to_sign_in
end
