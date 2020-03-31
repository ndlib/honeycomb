module ControllerHelpers
  def sign_in_admin
    user = FactoryGirl.create(:admin_user)
    sign_in user
    session[:netid] = user.username
    user
  end

  def sign_in_user
    user = FactoryGirl.create(:user)
    sign_in user
    session[:netid] = user.username
    user
  end
end
