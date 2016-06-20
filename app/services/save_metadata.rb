class SaveMetadata
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
    set_metadata
    if valid? && item.save
      index_item
      item.item_metadata
    else
      false
    end
  end

  private

  def index_item
    Index::Item.index!(item)
  end

  def fix_params
    @params = params.with_indifferent_access
    ParamCleaner.call(hash: params)
  end

  def set_metadata
    Metadata::Setter.call(item, params)
  end

  def valid?
    item.item_metadata.valid?
  end
end
