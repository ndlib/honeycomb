class ProcessItemUploadedImage
  attr_reader :item

  def self.call(item)
    new(item).save
  end

  def self.queue(item)
    ProcessItemImageJob.perform_later(item)
  end

  def initialize(item)
    @item = item
  end

  def save
    if uploaded_image.exists?
      processed_path = PreprocessImage.call(uploaded_image)
      copy_processed_image(processed_path)
      if item.save
        delete_processed_image(processed_path)
        item
      else
        false
      end
    else
      true
    end
  end

  def uploaded_image
    item.uploaded_image
  end

  def copy_processed_image(copy_path)
    file = File.open(copy_path)
    item.image = file
    file.close
    item.uploaded_image = nil
  end

  def delete_processed_image(processed_path)
    if File.exists?(processed_path)
      File.delete(processed_path)
    end
  end
end
