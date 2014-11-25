module ApplicationHelper

  def top_nav_links
    res = []
    if defined?(collection)
      res << link_to(collection.title, collection_items_path(collection))
    end
    if permission.user_is_administrator? || permission.user_is_admin_in_masquerade?
      res << link_to("Users", users_path)
    end
    if masquerade.masquerading?
      res << link_to("Cancel Masquerade", cancel_masquerades_path)
    end
    res
  end

  def display_notices
    content = raw("")
    if flash[:notice].present?
      content += content_tag(:div, raw(flash[:notice]), class: "alert alert-info")
    end
    if flash[:alert].present?
      content += content_tag(:div, raw(flash[:alert]), class: "alert alert-warning")
    end
    if flash[:success].present?
      content += content_tag(:div, raw(flash[:success]), class: "alert alert-success")
    end
    if flash[:error].present?
      content += content_tag(:div, raw(flash[:error]), class: "alert alert-danger")
    end
    content_tag(:div, content, id: "notices")
  end

  def display_errors(obj)
    ErrorMessageDecorator.new(obj).display_error
  end

  def masquerade
    @masquerade ||= Masquerade.new(self)
  end

  def permission
    @permission ||= SitePermission.new(current_user, self)
  end
end
