module CacheKeys
  module Custom
    # Generator for v1/showcases_controller
    class V1Showcases
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.exhibit, collection.showcases])
      end

      def show(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection, showcase.sections, showcase.items])
      end
    end
  end
end
