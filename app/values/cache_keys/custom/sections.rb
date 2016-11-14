module CacheKeys
  module Custom
    # Generator for sections_controller
    class Sections
      def edit(section:)
        CacheKeys::ActiveRecord.new.generate(record: [section, section.collection, section.item.media])
      end
    end
  end
end
