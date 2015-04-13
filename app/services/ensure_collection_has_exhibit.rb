class EnsureCollectionHasExhibit
  attr_reader :collection

  def self.call(collection)
    new(collection).ensure
  end

  def initialize(collection)
    @collection = collection
  end

  def ensure
    unless collection.exhibit
      create!
    end

    collection.exhibit
  end

  private

  def create!
    collection.create_exhibit(title: collection.title)
  end
end
