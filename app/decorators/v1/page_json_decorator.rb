
module V1
  class PageJSONDecorator < Draper::Decorator
    delegate :id, :collection, :unique_id, :updated_at, :name, :content, :items

    def self.display(showcase, json)
      new(showcase).display(json)
    end

    def at_id
      h.v1_page_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def slug
      CreateURLSlug.call(object.slug)
    end

    def additional_type
      "https://github.com/ndlib/honeycomb/wiki/Page"
    end

    def next
      SiteObjectsQuery.new.next(collection_object: object)
    end

    def previous
      SiteObjectsQuery.new.previous(collection_object: object)
    end

    def image
      if object.image
        V1::ImageJSONDecorator.new(object.image).to_hash
      end
    end

    def display(json)
      if object.present?
        json.set! "@context", "http://schema.org"
        json.set! "@type", "CreativeWork"
        json.set! "@id", at_id
        json.set! "isPartOf/collection", collection_url
        json.set! "additionalType", additional_type
        json.id unique_id
        json.slug slug
        json.name name
        json.image image
        json.content content
        json.last_updated updated_at
      end
    end
  end
end
