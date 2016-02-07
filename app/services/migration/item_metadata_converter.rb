module Migration
  class ItemMetadataConverter
    attr_reader :item

    def self.call
      Item.all.each do |item|
        puts "processing: #{item.id}"
        new(item).convert!
      end
    end

    def initialize(item)
      @item = item
    end

    def convert!
      fix("name")
      fix("description")

      item.save!
    end

    private

    def fix(field)
      if !item.metadata[field]
        item.metadata[field] = [item.send(field)]
      end
    end
  end
end
