class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    ItemsDecorator.new(children_query_recent)
  end

  def image_tag(width)
    h.image_tag(object.image.to_s, width: width)
  end

  def back_path
    if is_parent?
      h.collection_items_path(object.collection_id)
    else
      h.collection_item_children_path(object.collection_id, object.parent_id)
    end
  end

  def edit_path
    h.edit_collection_item_path(object.collection_id, object.id)
  end

  def show_path
    h.collection_item_path(object.collection_id, object.id)
  end

  private

  def children_query_recent
    children_query.recent(5)
  end

  def children_query
    @children_query ||= ItemQuery.new(object.children)
  end
end
