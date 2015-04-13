class SaveCollection
  attr_reader :params, :collection

  def self.call(collection, params)
    new(collection, params).save
  end

  def initialize(collection, params)
    @params = params
    @collection = collection
  end

  def save
    collection.attributes = params

    if collection.save
      check_unique_id
      EnsureCollectionHasExhibit.call(collection)
      true
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(collection)
  end
end
