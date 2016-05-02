module CacheKeys
  module Custom
    # Generator for v1/items_controller
    class V1Items
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items, collection.collection_configuration])
      end

      def show(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.children, item.collection.collection_configuration])
      end

      def showcases(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.showcases, item.collection.collection_configuration])
      end
    end
  end
end
