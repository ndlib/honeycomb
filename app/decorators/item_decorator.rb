class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    object.children.order(created_at: :desc).limit(5)
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
end
