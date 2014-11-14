class UserIsAdminPolicy

  def initialize(user)
    @user = user
  end


  def is_admin?
    @user.admin?
  end
end
