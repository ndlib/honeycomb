module CacheKeys
  module Custom
    # Generator for sections_controller
    class Sections
      def edit(section:)
        media = section.item ? section.item.media : ""
        CacheKeys::ActiveRecord.new.generate(record: [section, section.collection, media])
      end
    end
  end
end
