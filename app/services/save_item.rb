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

    if item.save && update_honeypot_image
      check_unique_id

      item
    else
      false
    end
  end

  private

  def pre_process_name
    if name_should_be_filename?
      item.name = GenerateNameFromFilename.call(item.image_file_name)
    end

    item.sortable_name = SortableNameConverter.convert(item.name)
  end

  def name_should_be_filename?
    item.new_record? && item.name.blank?
  end

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:image) if params[:image].nil?
  end

  def update_honeypot_image
    if params[:image]
      SaveHoneypotImage.call(item)
    else
      true
    end
  end

  def check_unique_id
    CreateUniqueId.call(item)
  end
end
