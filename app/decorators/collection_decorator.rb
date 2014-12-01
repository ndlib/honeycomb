class CollectionDecorator < Draper::Decorator
  delegate_all

  def item_count
    ItemQuery.new(object.items).search.exclude_children.count
  end
end
