module CacheKeys
  module Custom
    # Generator for showcases_controller
    class Showcases
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection.showcases, collection])
      end

      def edit(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection])
      end

      def title(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection])
      end
    end
  end
end
