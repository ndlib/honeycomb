module Index
  module Item
    def self.index!(item)
      index_item = item_to_waggle_item(item)
      Waggle.index!(index_item)
    end

    def self.api_data(item)
      V1::ItemJSONDecorator.new(item).to_hash
    end

    def self.item_to_waggle_item(item)
      Waggle::Item.new(api_data(item))
    end
  end
end
