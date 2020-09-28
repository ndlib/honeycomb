module Index
  module Collection
    def self.index!(collection:, items: collection.items, progress_bar: nil)
      return if items.count.zero? # purely for optimization to prevent unnecessary sql/http calls to solr
      set_configuration(collection: collection)
      waggle_items = items.map { |i| Waggle::Item.from_item(i) }
      waggle_items.each do |item|
        Waggle.index!(item)
        if !progress_bar.nil?
          progress_bar.increment
        end
      end
    rescue StandardError => exception
      notify_error(exception: exception, collection: collection, action: "index!")
    end

    def self.remove!(collection:, items: collection.items, progress_bar: nil)
      return if items.count.zero? # purely for optimization to prevent unnecessary sql/http calls to solr
      set_configuration(collection: collection)
      waggle_items = items.map { |i| Waggle::Item.from_item(i) }
      waggle_items.each do |item|
        Waggle.remove!(item)
        if !progress_bar.nil?
          progress_bar.increment
        end
      end
    rescue StandardError => exception
      notify_error(exception: exception, collection: collection, action: "remove!")
    end

    def self.notify_error(exception:, collection:, action:)
      Raven.capture_exception(exception)
      fail exception if Rails.env.development?
    end
    private_class_method :notify_error

    def self.set_configuration(collection:)
      config = CollectionConfigurationQuery.new(collection).find
      Waggle.set_configuration(config)
    end
    private_class_method :set_configuration

  end
end
