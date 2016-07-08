class CreateBeehiveURL
  # object can be a Collection, Showcase, or Item
  attr_reader :object, :custom_url_flag

  def self.call(object, custom_url_flag = false)
    new(object, custom_url_flag).create
  end

  def initialize(object, custom_url_flag)
    @object = object
    @custom_url_flag = custom_url_flag
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
    if collection.url_slug && custom_url_flag
      "#{Rails.configuration.settings.beehive_url}/#{collection.url_slug}"
    else
      "#{Rails.configuration.settings.beehive_url}/#{collection.unique_id}/#{CreateURLSlug.call(collection.name_line_1)}"
    end
  end

  def item_url
    "#{collection_url(object.collection)}/#{object.class.name.pluralize.downcase}/search?q=&view=grid&item=#{object.unique_id}"
  end

  def object_url
    "#{collection_url(object.collection)}/#{object.class.name.pluralize.downcase}/#{object.unique_id}/#{CreateURLSlug.call(object.name)}"
  end
end
