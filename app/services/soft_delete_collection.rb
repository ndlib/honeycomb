class SoftDeleteCollection
  attr_reader :collection

  def self.call(collection)
    new(collection).soft_delete!
  end

  def initialize(collection)
    @collection = collection
  end

  def soft_delete!
    collection.deleted = true
    collection.save
  end

  private

  def collection
    @collection ||= Collection.find(@collection.id)
  end
end
