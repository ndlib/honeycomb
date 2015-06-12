class ProcessUploadedImage
  attr_reader :object, :upload_field, :image_field

  def self.call(*args)
    new(*args).process
  end

  def initialize(object:, upload_field: "uploaded_image", image_field: "image")
    @object = object
    @upload_field = upload_field
    @image_field = image_field
  end

  def process
    if uploaded_image_exists?
      process_uploaded_image
    else
      true
    end
  end

  private

  def process_uploaded_image
    processed_path = PreprocessImage.call(uploaded_image)
    copy_processed_image(processed_path)
    begin
      save_object
    ensure
      delete_processed_image(processed_path)
    end
  end

  def save_object
    if object.save
      object
    else
      false
    end
  end

  def uploaded_image_exists?
    uploaded_image.exists?
  end

  def uploaded_image
    object.send(upload_field)
  end

  def copy_processed_image(copy_path)
    file = File.open(copy_path)
    object.send("#{image_field}=", file)
    file.close
    object.send("#{upload_field}=", nil)
  end

  def delete_processed_image(processed_path)
    if File.exists?(processed_path)
      File.delete(processed_path)
    end
  end
end
