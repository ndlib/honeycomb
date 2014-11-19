class UserCanEditPolicy

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def can_edit?
    if CollectionUser.where(collection_id: collection.id, user_id: user.id)
      true
    else
      false
    end
  end

end
