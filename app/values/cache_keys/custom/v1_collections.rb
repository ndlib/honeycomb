module CacheKeys
  module Custom
    # Generator for v1/collections_controller
    class V1Collections
      def index(collections:)
        CacheKeys::ActiveRecord.new.generate(record: [collections])
      end

      def show(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end

      def site_path(collection:, site_path:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, site_path])
      end
    end
  end
end
