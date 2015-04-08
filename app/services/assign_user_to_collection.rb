class AssignUserToCollection
  attr_reader :collection, :user

  def self.call(collection, user)
    new(collection, user).assign!
  end

  def initialize(collection, user)
    @collection = collection
    @user = user
  end

  def assign!
    if collection && user
      collection_user.collection_id = collection.id
      collection_user.user_id = user.id
      if collection_user.save
        collection_user
      else
        false
      end
    else
      false
    end
  end

  private

  def collection_user
    @collection_user ||= CollectionUser.where(collection_id: collection.id, user_id: user.id).first
    if @collection_user.nil?
      @collection_user = CollectionUser.new()
    end
    @collection_user
  end

end
