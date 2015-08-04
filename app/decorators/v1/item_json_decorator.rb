module V1
  class ItemJSONDecorator < Draper::Decorator
    delegate :id, :name, :children, :parent, :collection, :unique_id, :updated_at

    def self.display(item, json)
      new(item).display(json)
    end

    def at_id
      h.v1_item_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def description
      object.description.to_s
    end

    def slug
      CreateURLSlug.call(object.name)
    end

    def image
      if object.image_ready? && object.honeypot_image
        object.honeypot_image.json_response
      end
    end

    def metadata
      V1::MetadataJSON.metadata(object)
    end

    def display(json)
      if object.present?
        set_header_keys(json)
        set_attribute_keys(json)
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

    private

    def set_header_keys(json)
      json.set! "@context", "http://schema.org"
      json.set! "@type", "CreativeWork"
      json.set! "@id", at_id
      json.set! "isPartOf/collection", collection_url
    end

    def set_attribute_keys(json)
      json.id unique_id
      json.slug slug
      json.name name
      json.description description.to_s
      json.image image
      json.metadata metadata
      json.last_updated updated_at
    end
  end
end
