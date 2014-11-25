class ItemsDecorator < Draper::CollectionDecorator
  def decorator_class
    ItemDecorator
  end
end
