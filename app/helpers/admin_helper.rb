module AdminHelper
  def admin_only
    yield if UserIsAdmin.call(current_user)
  end
end
