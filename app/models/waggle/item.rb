module Waggle
  class Item
    TYPE = "Item"
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def id
      data.fetch("id")
    end

    def collection_id
      data.fetch("collection_id")
    end

    def type
      TYPE
    end

    def last_updated
      @last_updated ||= Time.parse(data.fetch("last_updated")).utc
    end

    def thumbnail_url
      if thumbnail
        thumbnail["contentUrl"]
      end
    end

    def metadata
      @metadata ||= Waggle::Metadata::Set.new(data.fetch("metadata"), metadata_configuration)
    end

    def method_missing(method_name, *args, &block)
      if metadata.field?(method_name)
        metadata.value(method_name)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      if metadata.field?(method_name)
        true
      else
        super
      end
    end

    def self.load(id)
      raw_data = File.read(Rails.root.join("spec/fixtures/v1/items/#{id}.json"))
      new(JSON.parse(raw_data).fetch("items"))
    end

    private

    def metadata_configuration
      ::Metadata::Configuration.item_configuration
    end

    def image
      data.fetch("image")
    end

    def thumbnail
      if image
        image["thumbnail/small"]
      end
    end
  end
end
