module ApplicationHelper
  def image_zoom(image_name, options = {})
    @image_zoom_id ||= 0
    @image_zoom_id += 1
    id ||= "imageZoom#{@image_zoom_id}"
    options = options.reverse_merge({
      id: id,
      class: "image-zoom image-zoom-immediate",
      style: "width: 100%; height: 100%",
      "data-target" => image_name,
    }).with_indifferent_access
    overlay = options.delete("overlay")
    caption = options.delete("caption")
    item = options.delete("item")
    if overlay
      options["data-overlay"] = overlay.to_json
    end
    if item
      content = item_attribution(item)
    else
      content = "".html_safe
    end
    if caption
      content += caption_container(caption)
    end
    zoom_content = content_tag(:div, content, options)
  end

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

  def collection_nav(collection, active)
    render partial: '/collections/collection_nav', locals: { collection: collection, active: active }
  end

  def collection_title(collection, section_title)
    render partial: '/collections/collection_title', locals: { collection: collection, section_title: section_title }
  end

end
