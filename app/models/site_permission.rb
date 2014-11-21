class SitePermission
  attr_reader :user, :controller

  def initialize(user, controller)
    @user = user
    @controller = controller
  end

  def user_is_administrator?
    UserIsAdmin.call(user)
  end

  def user_is_admin_in_masquerade?
    m = Masquerade.new(controller)
    m.masquerading? && UserIsAdmin.call(m.original_user)
  end

  def user_is_curator?(collection)
    UserIsCurator.call(user, collection)
  end
end
