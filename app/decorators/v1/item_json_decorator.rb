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
      h.v1_collection_url(collection_id)
    end

    def collection_id
      object.collection.unique_id
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
      json.id unique_id
      json.collection_id collection_id
      json.slug slug
      json.name name
      json.description description.to_s
      json.image_status object.image_status
      json.image image
      json.metadata metadata
      json.last_updated updated_at
    end
  end
end
