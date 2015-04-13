class CollectionUserListDecorator < Draper::CollectionDecorator
  def decorator_class
    CollectionUserDecorator
  end

  def editor_hashes
    decorated_collection.collect(&:editor_hash)
  end
end
