class UserIsAdmin

  def self.call(user)
    new(user).is_admin?
  end

  def initialize(user)
    @user = user
  end

  def is_admin?
    @user.admin?
  end
end
