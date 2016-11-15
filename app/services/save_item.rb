class SaveItem
  attr_reader :params, :item, :uploaded_image

  def self.call(item, params, index: true)
    new(item, params).save(index: index)
  end

  def initialize(item, params)
    @params = params
    @item = item
  end

  def save(index: true)
    pre_process

    if item.save && process_uploaded_image
      index_item if index
      fix_image_references
      item
    else
      false
    end
  end

  private

  def pre_process
    fix_params
    item.attributes = params
    check_user_defined_id
    check_unique_id
    pre_process_name
  end

  def fix_params
    @params = params.with_indifferent_access
    fix_name_param!
    fix_image_param!
    ParamCleaner.call(hash: params)
  end

  def pre_process_name
    if name_should_be_filename?
      data = { "name" => GenerateNameFromFilename.call(uploaded_image.original_filename) }
      Metadata::Setter.call(item, data)
    end
  end

  def name_should_be_filename?
    item.new_record? && item.name.blank?
  end

  def check_user_defined_id
    CreateUserDefinedId.call(item)
  end

  def fix_image_param!
    @uploaded_image = params[:uploaded_image]
    params.delete(:uploaded_image)
  end

  def fix_name_param!
    if params[:name]
      data = { "name" => params.delete(:name) }
      Metadata::Setter.call(item, data)
    end
  end

  def process_uploaded_image
    if uploaded_image.present?
      item.media = FindOrCreateImage.call(file: uploaded_image, collection_id: item.collection_id)
      return item.save
    end
    true
  end

  def check_unique_id
    CreateUniqueId.call(item)
  end

  def index_item
    Index::Item.index!(item)
  end

  def fix_image_references
    @item.pages.each do |page|
      ReplacePageItem.call(page, @item)
    end
  end
end
