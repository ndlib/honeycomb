class SaveExhibit
  attr_reader :params, :exhibit

  def self.call(exhibit, params)
    new(exhibit, params).save
  end

  def initialize(exhibit, params)
    @params = params
    @exhibit = exhibit
  end

  def save
    fix_image_param!
    exhibit.attributes = params

    (exhibit.save && process_uploaded_image)
  end

  private

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def process_uploaded_image
    if params[:uploaded_image]
      QueueJob.call(ProcessImageJob, object: exhibit)
    else
      true
    end
  end
end
