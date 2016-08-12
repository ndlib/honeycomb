module V1
  class ItemJSONDecorator < Draper::Decorator
    delegate :id, :name, :children, :parent, :user_defined_id, :collection, :unique_id, :updated_at

    def self.display(item, json)
      new(item).display(json)
    end

    def at_id
      h.v1_item_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(collection_id)
    end

    def showcases_url
      h.v1_item_showcases_url(object.unique_id)
    end

    def pages_url
      h.v1_item_pages_url(object.unique_id)
    end

    def collection_id
      object.collection.unique_id
    end

    def description
      object.description.to_s
    end

    def additional_type
      "https://github.com/ndlib/honeycomb/wiki/Item"
    end

    def slug
      CreateURLSlug.call(object.name)
    end

    def media
      if object.media
      case object.media.type
        when "Image"
          V1::ImageJSONDecorator.new(object.media).to_hash
        else
          SerializeMedia.to_hash(media: object.media)
        end
      end
    end

    def metadata
      V1::MetadataJSON.metadata(object)
    end

    def display(json)
      if object.present?
        set_json_keys(json)
      end
    end

    def to_builder
      Jbuilder.new do |json|
        display(json)
      end
    end

    def to_json
      to_builder.target!
    end

    def to_hash
      JSON.parse(to_json)
    end

    private

    def set_json_keys(json) # rubocop:disable Metrics/AbcSize
      json.set! "@context", "http://schema.org"
      json.set! "@type", "CreativeWork"
      json.set! "@id", at_id
      json.set! "isPartOf/collection", collection_url
      json.set! "hasPart/showcases", showcases_url
      json.set! "hasPart/pages", pages_url
      json.set! "additionalType", additional_type
      json.id unique_id
      json.user_defined_id user_defined_id
      json.collection_id collection_id
      json.slug slug
      json.name name
      json.description description.to_s
      json.media media
      json.metadata metadata
      json.last_updated updated_at
    end
  end
end
