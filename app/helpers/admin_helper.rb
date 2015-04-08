module AdminHelper
  def admin_only
    if UserIsAdmin.call(current_user)
      yield
    end
  end
end
