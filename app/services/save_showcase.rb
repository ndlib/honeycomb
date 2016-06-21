class SaveShowcase
  attr_reader :params, :showcase, :uploaded_image

  def self.call(showcase, params)
    new(showcase, params).save
  end

  def initialize(showcase, params)
    @params = params
    @showcase = showcase
  end

  def save
    fix_image_param!

    showcase.attributes = params
    check_unique_id

    if showcase.save && process_uploaded_image
      true
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(showcase)
  end

  def fix_image_param!
    @uploaded_image = params[:uploaded_image]
    params.delete(:uploaded_image)
  end

  def process_uploaded_image
    if uploaded_image.present?
      showcase.image = FindOrCreateImage.call(file: uploaded_image, collection_id: showcase.collection_id)
      return showcase.save
    end
    true
  end
end
