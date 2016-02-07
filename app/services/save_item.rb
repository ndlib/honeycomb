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
    fix_params
    item.attributes = params
    pre_process_metadata
    pre_process_name
    check_unique_id
    check_user_defined_id

    if item.save && process_uploaded_image
      index_item
      fix_image_references
      item
    else
      false
    end
  end

  private

  def fix_params
    fix_image_param!
    ParamCleaner.call(hash: params)
  end

  def pre_process_metadata
    MetadataInputCleaner.call(item)
  end

  def pre_process_name
    if name_should_be_filename?
      item.name = GenerateNameFromFilename.call(item.uploaded_image_file_name)
    end

    item.sortable_name = SortableNameConverter.convert(item.name)
  end

  def name_should_be_filename?
    item.new_record? && item.name.blank?
  end

  def check_user_defined_id
    CreateUserDefinedId.call(item)
  end

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def process_uploaded_image
    if params[:uploaded_image]
      item.image_processing!
      begin
        QueueJob.call(ProcessImageJob, object: item)
      rescue Bunny::TCPConnectionFailedForAllHosts
        item.image_unavailable!
      end
    elsif item.image_unavailable?
      set_no_image
      true
    else
      true
    end
  end

  def check_unique_id
    CreateUniqueId.call(item)
  end

  def index_item
    Index::Item.index!(item)
  end

  def set_no_image
    item.no_image!
  end

  def fix_image_references
    @item.pages.each do |page|
      ReplacePageItem.call(page, @item)
    end
  end
end
