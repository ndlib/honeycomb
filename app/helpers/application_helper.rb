module ApplicationHelper
  def display_errors(obj)
    ErrorMessages.new(obj).display_error
  end

  def masquerade
    @masquerade ||= Masquerade.new(self)
  end

  def permission
    @permission ||= SitePermission.new(current_user, self)
  end

  def page_title(page_title, collection = false)
    if collection
      page_title += " - #{collection.name_line_1}"
    end

    content_for(:page_title, page_title)
  end

  def collection_nav(collection, left_nav_section)
    content_for(:collection_top_nav, Nav::CollectionTop.new(collection).display)
    content_for(:left_nav, Nav::CollectionLeft.new(collection).display(left_nav_section))
  end

  def learn_more_button(path)
    if path == "#"
      link_to raw("<i class=\"glyphicon glyphicon-education\"></i> SUBMIT FEEDBACK"), "https://docs.google.com/a/nd.edu/forms/d/1PH99cRyKzhZ6rV-dCJjrfkzdThA2n1GvoE9PT6kCkSk/viewform?entry.1268925684=#{request.original_url}", class: "btn btn-large btn-hollow", target: "blank"
    else
      link_to raw("<i class=\"glyphicon glyphicon-education\"></i> #{t('buttons.help')}"), path, class: "btn btn-large btn-hollow"
    end
  end

  def back_button(path)
    link_to(raw("<span class=\"mdi-navigation-arrow-back\"></span>"), path, class: "btn btn-large btn-hollow")
  end

  def back_action_bar(back_path, learn_more_path)
    render(partial: "/shared/back_action_bar", locals: { back_path: back_path, learn_more_path: learn_more_path })
  end

  def no_back_action_bar(learn_more_path)
    render(partial: "/shared/no_back_action_bar", locals: { learn_more_path: learn_more_path })
  end

  def permission
    @permission ||= SitePermission.new(current_user, self)
  end

  def admin_only
    if permission.user_is_administrator?
      yield
    end
  end

  def admin_or_admin_masquerading_only
    if permission.user_is_admin_in_masquerade? || permission.user_is_administrator?
      yield
    end
  end

  def user_edits(collection)
    if permission.user_is_admin_in_masquerade? || permission.user_is_administrator? || permission.user_is_editor?(collection)
      yield
    end
  end
end
