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
      collection
    else
      false
    end
  end

end