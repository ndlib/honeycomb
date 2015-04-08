module ControllerHelpers
  def sign_in(user = double('user', id: 1))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end

  def sign_in_admin()
    user = instance_double(User, id: 1, username: 'admin', admin: true, admin?: true)
    sign_in(user)
    user
  end
end
