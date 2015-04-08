class CreateBeehiveURL
  # object can be a Collection, Showcase, or Item
  attr_reader :object

  def self.call(object)
    new(object).create
  end

  def initialize(object)
    @object = object
  end

  def create
    if @object.is_a?(Collection)
      collection_url(@object)
    else
      object_url
    end

  end

  private
  def collection_url(collection)
    "#{Rails.configuration.settings.beehive_url}/#{collection.unique_id}/#{CreateURLSlug.call(collection.title)}"
  end

  def object_url
    "#{collection_url(object.collection)}/#{object.class.name.pluralize.downcase}/#{object.unique_id}/#{CreateURLSlug.call(object.title)}"
  end

end
