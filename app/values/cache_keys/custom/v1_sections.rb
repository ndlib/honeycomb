module CacheKeys
  module Custom
    # Generator for v1/sections_controller
    class V1Sections
      def show(decorated_section:)
        CacheKeys::ActiveRecord.new.generate(record: [decorated_section.object,
                                                      decorated_section.item,
                                                      decorated_section.item_children,
                                                      decorated_section.next,
                                                      decorated_section.previous,
                                                      decorated_section.collection,
                                                      decorated_section.collection.collection_configuration,
                                                      decorated_section.showcase])
      end
    end
  end
end
