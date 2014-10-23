module ApplicationHelper

  def top_nav_links
    res = []
    if defined?(collection)
      res << link_to(collection.title, collection_items_path(collection))
    end

    res
  end

  def display_notices
    content = raw("")
    if flash[:notice].present?
      content += content_tag(:div, raw(flash[:notice]), class: "alert alert-info")
    end
    if flash[:alert].present?
      content += content_tag(:div, raw(flash[:alert]), class: "alert")
    end
    if flash[:success].present?
      content += content_tag(:div, raw(flash[:success]), class: "alert alert-success")
    end
    if flash[:error].present?
      content += content_tag(:div, raw(flash[:error]), class: "alert alert-error")
    end
    content_tag(:div, content, id: "notices")
  end

end
