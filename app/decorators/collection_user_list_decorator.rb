class CollectionUserListDecorator < Draper::CollectionDecorator
  def decorator_class
    CollectionUserDecorator
  end

  def editor_hashes
    decorated_collection.collect{|collection_user| collection_user.editor_hash}
  end
end
