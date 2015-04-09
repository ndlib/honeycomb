module ControllerHelpers
  def sign_in_admin
    user = instance_double(User, id: 1, username: 'admin', admin: true, admin?: true)
    sign_in(user)
    user
  end

  def sign_in_user
    user = instance_double(User, id: 1, username: 'user', admin: false, admin?: false)
    sign_in(user)
    user
  end

  def sign_in(user)
    if user.nil?
      warden_nil_user
    else
      warden_user(user)
    end
  end

  def warden_nil_user
    allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, scope: :user)
    allow(controller).to receive(:current_user).and_return(nil)
  end

  def warden_user(user)
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
