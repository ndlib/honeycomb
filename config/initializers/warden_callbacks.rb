Warden::Manager.after_set_user do |user, auth|
  token = GenerateAccessToken.call
  auth.session[:token] = token
  auth.session[:username] = user.username
end
