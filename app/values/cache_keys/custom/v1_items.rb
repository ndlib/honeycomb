module CacheKeys
  module Custom
    # Generator for v1/items_controller
    class V1Items
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items, collection.collection_configuration, Media.joins(:items).where(collection_id: collection.id)])
      end

      def show(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.children, item.parent, item.media, item.collection.collection_configuration])
      end

      def showcases(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.showcases, item.media, item.collection.collection_configuration])
      end

      def pages(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.pages, item.media, item.collection.collection_configuration])
      end
    end
  end
end
