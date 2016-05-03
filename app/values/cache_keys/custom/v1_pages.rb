module CacheKeys
  module Custom
    # Generator for v1/pages_controller
    class V1Pages
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.pages])
      end

      def show(page:)
        CacheKeys::ActiveRecord.new.generate(record: [page.object,
                                                      page.collection,
                                                      page.collection.collection_configuration,
                                                      page.items,
                                                      page.next])
      end
    end
  end
end
