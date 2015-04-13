require 'draper'

class Nav::Top < Draper::Decorator
  def display
    h.render partial: 'shared/top_nav', locals: { nav: self }
  end

  def current_user_display_name
    if object.respond_to?(:current_user) && object.current_user
      object.current_user.display_name
    else
      'no user'
    end
  end

  def bar_size_class
    "#{h.request.original_fullpath == h.root_path ? 'large' : 'short'}"
  end
end
