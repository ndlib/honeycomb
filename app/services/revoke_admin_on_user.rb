class RevokeAdminOnUser
  attr_reader :user

  def self.call(user)
    new(user).revoke_admin!
  end

  def initialize(user)
    @user = user
  end

  def revoke_admin!
    user.admin = false
    user.save
  end

  private

  def user
    @user ||= User.find_for_authentication(@user)
  end
end
