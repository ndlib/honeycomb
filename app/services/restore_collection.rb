class RestoreCollection
  attr_reader :collection

  def self.call(collection)
    new(collection).restore!
  end

  def initialize(collection)
    @collection = collection
  end

  def restore!
    collection.deleted = false
    collection.save
  end

  private

  def collection
    @collection ||= Collection.find(@collection.id)
  end
end
