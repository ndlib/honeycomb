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
    set_metadata
    if valid? && item.save
      item.item_metadata
    else
      false
    end
  end

  private

  def set_metadata
    if params.present?
      Metadata::Setter.call(item, params)
    end
  end

  def valid?
    item.item_metadata.valid?
  end
end
