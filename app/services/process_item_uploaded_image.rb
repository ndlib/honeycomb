class ProcessItemUploadedImage
  MAX_PIXELS = 16000000
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
      process_original
      copy_processed_image
      if item.save
        delete_processed_image
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

  def processing_needed?
    exceeds_max_pixels? || tiff?
  end

  def tiff?
    uploaded_image.content_type == "image/tiff"
  end

  def exceeds_max_pixels?
    original_pixels > MAX_PIXELS
  end

  def original_pixels
    if @original_pixels.nil?
      size = FastImage.size(uploaded_image.path)
      @original_pixels = size[0] * size[1]
    end
    @original_pixels
  end

  def process_original
    if processing_needed?
      processor_attachment.reprocess!
    end
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
    style = "#{MAX_PIXELS}@"
    if tiff?
      style = [style, :jpg]
    end
    style
  end

  def processed_path
    @processed_path ||= processor_attachment.path(:processed)
  end

  def copy_path
    if processing_needed?
      processed_path
    else
      uploaded_image.path
    end
  end

  def copy_processed_image
    file = File.open(copy_path)
    item.image = file
    file.close
    item.uploaded_image = nil
  end

  def delete_processed_image
    if File.exists?(processed_path)
      File.delete(processed_path)
    end
  end
end
