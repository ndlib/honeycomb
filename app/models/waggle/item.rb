module Waggle
  class Item
    attr_reader :data

    def self.from_item(item)
      api_data = V1::ItemJSONDecorator.new(item).to_hash
      new(api_data)
    end

    def initialize(data)
      @data = data
    end

    def id
      data.fetch("id")
    end

    def unique_id
      id
    end

    def at_id
      data.fetch("@id")
    end

    def collection_id
      data.fetch("collection_id")
    end

    def type
      if media
        media["@type"]
      else
        "Unknown"
      end
    end

    def last_updated
      @last_updated ||= Time.zone.parse(data.fetch("last_updated")).utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    def thumbnail_url
      if media
        case media["@type"]
        when "AudioObject"
          media["thumbnailUrl"]
        when "VideoObject"
          media["thumbnailUrl"]
        when "ImageObject"
          media["thumbnail/medium"]["contentUrl"]
        end
      end
    end

    def metadata
      @metadata ||= Waggle::Metadata::Set.new(data.fetch("metadata"), metadata_configuration)
    end

    def self.load(id)
      ItemQuery.new.public_find(id)
    end

    private

    def metadata_configuration
      Waggle.configuration
    end

    def media
      data.fetch("media")
    end
  end
end
