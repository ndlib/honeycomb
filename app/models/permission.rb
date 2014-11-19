class Permission

  def initialize(current_user, controller)
    @current_user = current_user
    @controller = controller
  end

  def current_user_is_administrator?
    UserIsAdminPolicy.new(@current_user).is_admin?
  end

  def current_user_is_admin_in_masquerade?
    m = Masquerade.new(@controller)
    m.masquerading? && UserIsAdminPolicy.new(m.original_user).is_admin?
  end

  def current_user_can_edit_collection?
    UserCanEditPolicy.new(@current_user, @current_collection).can_edit?
  end
end
