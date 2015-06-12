class SaveShowcase
  attr_reader :params, :showcase

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

    if showcase.save && process_uploaded_image
      check_unique_id
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
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def process_uploaded_image
    if params[:uploaded_image]
      QueueJob.call(ProcessImageJob, object: showcase)
    else
      true
    end
  end
end
