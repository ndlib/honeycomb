module CacheKeys
  module Custom
    # Generator for collections_controller
    class Collections
      def index(collections:)
        CacheKeys::ActiveRecord.new.generate(record: collections)
      end

      def settings(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end

      def site_setup(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end
    end
  end
end
