class SetAdminOnUser
  attr_reader :user

  def self.call(user)
    new(user).set_admin!
  end

  def initialize(user)
    @user = user
  end

  def set_admin!
    user.admin = true
    user.save
  end

  private

  def user
    @user ||= User.find_for_authentication(@user)
  end
end
