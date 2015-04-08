class UserIsEditor

  def self.call(user, collection)
    new(user, collection).is_editor?
  end

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def is_editor?
    if CollectionUser.where(collection_id: collection.id, user_id: user.id).first
      true
    else
      false
    end
  end

  private

  def collection
     @collection ||= Collection.where(collection.id)
  end

  def user
    @user || User.where(user.id)
  end
end
