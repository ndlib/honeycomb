class UserIsCurator

  def self.call(user, collection)
    new(user, collection).is_curator?
  end

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def is_curator?
    if CollectionUser.where(collection_id: collection.id, user_id: user.id).first
      true
    else
      false
    end
  end

end
