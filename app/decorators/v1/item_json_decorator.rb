module V1
  class ItemJSONDecorator < Draper::Decorator
    delegate :id, :name, :children, :parent, :collection, :unique_id, :updated_at

    def self.display(item, json)
      new(item).display(json)
    end

    def self.to_json(item)
      json = Jbuilder.new
      new(item).to_builder(json)
      json.target!
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

    def transcription
      object.transcription.to_s
    end

    def slug
      CreateURLSlug.call(object.name)
    end

    def image
      if object.image_ready? && object.honeypot_image
        object.honeypot_image.json_response
      else
        nil
      end
    end

    def metadata
      V1::MetadataJSON.metadata(object)
    end

    def display(json)
      if self.present?
        json.partial! "/v1/items/item", item_object: self
      end
    end

    def to_builder(json)
      json.set! "@context", "http://schema.org"
      json.set! "@type", "CreativeWork"
      json.set! "@id", at_id
      json.set! "isPartOf/collection", collection_url
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
