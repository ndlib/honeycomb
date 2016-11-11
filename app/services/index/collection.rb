module Index
  module Collection
    def self.index!(collection:, items: collection.items)
      return if items.count == 0 # purely for optimization to prevent unnecessary sql/http calls to solr
      set_configuration(collection: collection)
      waggle_items = items.map { |i| Waggle::Item.from_item(i) }
      Waggle.index!(*waggle_items)
    rescue StandardError => exception
      notify_error(exception: exception, collection: collection, action: "index!")
    end

    private

    def self.notify_error(exception:, collection:, action:)
      NotifyError.call(exception: exception, parameters: { collection: collection }, component: to_s, action: action)
      if Rails.env.development?
        raise exception
      end
    end

    def self.set_configuration(collection: collection)
      config = CollectionConfigurationQuery.new(collection).find
      Waggle.set_configuration(config)
    end
  end
end
