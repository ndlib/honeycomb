class SaveItem
  attr_reader :params, :item

  def self.call(item, params)
    new(item, params).save
  end

  def initialize(item, params)
    @params = params
    @item = item
  end

  def save
    fix_image_param!

    item.attributes = params
    pre_process_name

    if item.save && process_uploaded_image
      check_unique_id

      item
    else
      false
    end
  end

  private

  def pre_process_name
    if name_should_be_filename?
      item.name = GenerateNameFromFilename.call(item.uploaded_image_file_name)
    end

    item.sortable_name = SortableNameConverter.convert(item.name)
  end

  def name_should_be_filename?
    item.new_record? && item.name.blank?
  end

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def process_uploaded_image
    if params[:uploaded_image]
      QueueJob.call(ProcessImageJob, object: item)
    else
      true
    end
  end

  def check_unique_id
    CreateUniqueId.call(item)
  end
end
