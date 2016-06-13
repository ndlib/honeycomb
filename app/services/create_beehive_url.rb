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
    elsif @object.is_a?(Item)
      item_url
    else
      object_url
    end
  end

  private

  def collection_url(collection)
    if collection.url_slug
      "#{Rails.configuration.settings.beehive_url}/#{collection.url_slug}"
    else
      "#{Rails.configuration.settings.beehive_url}/#{collection.unique_id}#{CreateURLSlug.call(collection.name_line_1)}"
    end
  end

  def item_url
    "#{collection_url(object.collection)}/#{object.class.name.pluralize.downcase}/search?q=&view=grid&item=#{object.unique_id}"
  end

  def object_url
    "#{collection_url(object.collection)}/#{object.class.name.pluralize.downcase}/#{object.unique_id}/#{CreateURLSlug.call(object.name)}"
  end
end
