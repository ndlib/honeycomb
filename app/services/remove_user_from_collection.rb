class RemoveUserFromCollection
  attr_reader :collection, :user

  def self.call(collection, user)
    new(collection, user).delete!
  end

  def initialize(collection, user)
    @collection = collection
    @user = user

  end

  def delete!
    collection_user.destroy
  end

  private

  def collection_user
     @collection_user ||= CollectionUser.find_by! collection_id: collection.id, user_id: user.id
    if @collection_user.nil?
      @collection_user = CollectionUser.new()
    end
    @collection_user
  end

end
