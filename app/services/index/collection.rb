module Index
  module Collection
    def self.index!(collection:, items: collection.items)
      return if items.count == 0 # purely for optimization to prevent unnecessary sql/http calls to solr
      Waggle.set_configuration(get_configuration(collection))
      waggle_items = items.map { |i| item_to_waggle_item(i) }

      Waggle.index!(*waggle_items)
    rescue StandardError => exception
      notify_error(exception: exception, collection: collection, action: "index!")
    end

    def self.item_to_waggle_item(item)
      Waggle::Item.from_item(item)
    end

    private_class_method :item_to_waggle_item

    def self.notify_error(exception:, collection:, action:)
      NotifyError.call(exception: exception, parameters: { collection: collection }, component: to_s, action: action)
      if Rails.env.development?
        raise exception
      end
    end
    private_class_method :notify_error

    def self.get_configuration(collection)
      CollectionConfigurationQuery.new(collection).find
    end
  end
end
