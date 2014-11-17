class ItemDecorator < Draper::Decorator
  delegate_all

  def parent?
    object.parent_id.nil?
  end

  def recent_children
    object.children.order(created_at: :desc).limit(5)
  end

  def image_tag(width)
    h.image_tag(object.image.to_s, width: width)
  end
end
