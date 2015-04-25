class ProcessItemUploadedImage
  attr_reader :item

  def self.call(item)
    new(item).save
  end

  def initialize(item)
    @item = item
  end

  def save
    if uploaded_image.exists?
      process_original
      copy_processed_image
      if item.save
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

  def process_original
    processor_attachment.reprocess!
  end

  def processor_attachment
    @processor_attachment ||= Paperclip::Attachment.new(:uploaded_image, item, processor_options)
  end

  def processor_options
    new_options = uploaded_image.options.clone
    new_options[:styles] = new_options[:styles].merge({processed: processor_style})
    new_options
  end

  def processor_style
    style = "16000000@"
    if uploaded_image.content_type == "image/tiff"
      style = [style, :jpg]
    end
    style
  end

  def processed_path
    processor_attachment.path(:processed)
  end

  def copy_processed_image
    file = File.open(processed_path)
    item.image = file
    file.close
    # item.uploaded_image = nil
  end
end
