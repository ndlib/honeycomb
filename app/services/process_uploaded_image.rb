class ProcessUploadedImage
  attr_reader :object, :upload_field, :image_field

  def self.call(*args)
    new(*args).process
  end

  def initialize(object:, upload_field: :uploaded_image, image_field: :image)
    @object = object
    @upload_field = upload_field
    @image_field = image_field
  end

  def process
    if uploaded_image.exists?
      processed_path = PreprocessImage.call(uploaded_image)
      copy_processed_image(processed_path)
      if object.save
        delete_processed_image(processed_path)
        object
      else
        false
      end
    else
      true
    end
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
