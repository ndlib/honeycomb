module ApplicationHelper

  def top_nav_links
    res = []
    if defined?(collection)
      res << link_to(collection.title, collection_items_path(collection))
    end

    res
  end
end
