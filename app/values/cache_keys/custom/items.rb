module CacheKeys
  module Custom
    # Generator for items_controller
    class Items
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items])
      end

      def edit(decorated_item:)
        CacheKeys::ActiveRecord.new.generate(record: [decorated_item.collection,
                                                      decorated_item.recent_children,
                                                      decorated_item.object,
                                                      decorated_item.showcases,
                                                      decorated_item.pages,
                                                      decorated_item.media])
      end
    end
  end
end
