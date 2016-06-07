class SetCollectionSlug
  attr_reader :collection, :slug

  def self.call(collection, slug)
    new(collection, slug).set_slug!
  end

  def initialize(collection, slug)
    @collection = collection
    @slug = slug
  end

  def set_slug!
    collection.url_slug = CreateURLSlug.call(@slug)
    if collection.valid?
      collection.save!
    else
      false
    end
  end
end
