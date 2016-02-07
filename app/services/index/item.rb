module Index
  module Item
    def self.index!(item)
      Waggle.set_configuration(get_configuration(item))
      index_item = item_to_waggle_item(item)
      Waggle.index!(index_item)
    rescue StandardError => exception
      notify_error(exception: exception, item: item, action: "index!")
    end

    def self.remove!(item)
      index_item = item_to_waggle_item(item)
      Waggle.remove!(index_item)
    rescue StandardError => exception
      notify_error(exception: exception, item: item, action: "remove!")
    end

    def self.remove_all!(items)
      items.each do |item|
        remove!(item)
      end
    end

    def self.index_all!(items)
      items.each do |item|
        index!(item)
      end
    end

    def self.item_to_waggle_item(item)
      Waggle::Item.from_item(item)
    end
    private_class_method :item_to_waggle_item

    def self.notify_error(exception:, item:, action:)
      NotifyError.call(exception: exception, parameters: { item: item }, component: to_s, action: action)
      if Rails.env.development?
        raise exception
      end
    end
    private_class_method :notify_error

    def self.get_configuration(item)
      CollectionConfigurationQuery.new(item.collection).find
    end
  end
end
