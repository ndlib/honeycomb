module Waggle
  class Item
    attr_reader :data, :decoratedItem

    def self.from_item(item)
      json_item = V1::ItemJSONDecorator.new(item)
      new(json_item, json_item.to_hash)
    end

    def self.from_hash(hash)
      new(nil, hash)
    end

    def initialize(json_item, hash)
      @decoratedItem = json_item
      @data = hash
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
        "Metadata Only"
      end
    end

    def children
      return [] if !decoratedItem
      decoratedItem.children
    end

    def is_parent
      parent.nil?
    end

    def parent
      return nil if !decoratedItem
      decoratedItem.parent
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
          if media["thumbnail/medium"]
            media["thumbnail/medium"]["contentUrl"]
          else
            ""
          end
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
