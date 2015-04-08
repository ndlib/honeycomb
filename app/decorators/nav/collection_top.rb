require 'draper'

class Nav::CollectionTop < Draper::Decorator
  def display
    h.render partial: 'shared/collection_top_nav', locals: { nav: self }
  end

  def collection
    object
  end

  def recent_collections
    CollectionQuery.new.for_top_nav(h.current_user, object)
  end
end
