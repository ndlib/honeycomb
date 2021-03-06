module CacheKeys
  module Custom
    # Generator for v1/showcases_controller
    class V1Showcases
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.showcases])
      end

      def show(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase.object,
                                                      showcase.collection,
                                                      showcase.collection.collection_configuration,
                                                      showcase.sections,
                                                      showcase.items,
                                                      showcase.items_media,
                                                      showcase.next])
      end
    end
  end
end
