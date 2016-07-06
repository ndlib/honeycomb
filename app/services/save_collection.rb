class SaveCollection
  attr_reader :params, :collection, :uploaded_image

  def self.call(collection, params)
    new(collection, params).save
  end

  def initialize(collection, params)
    @params = params
    @collection = collection
  end

  def save
    fix_image_param!
    fix_url!
    collection.attributes = params
    collection.url_slug = CreateURLSlug.call(params[:url_slug]) if params[:url_slug]
    check_unique_id
    if collection.save && process_uploaded_image
      ensure_configuration_setup
      true
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(collection)
  end

  def fix_image_param!
    @uploaded_image = params[:uploaded_image]
    params.delete(:uploaded_image)
  end

  def fix_url!
    if params[:url].present?
      params[:url] = "http://#{params[:url]}" unless params[:url][/^https?/]
    end
  end

  def process_uploaded_image
    if uploaded_image.present?
      collection.image = FindOrCreateImage.call(file: uploaded_image, collection_id: collection.id)
      return collection.save
    end
    true
  end

  def ensure_configuration_setup
    CreateCollectionConfiguration.call(collection)
  end
end
