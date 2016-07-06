
module V1
  class ShowcaseJSONDecorator < Draper::Decorator
    delegate :id, :description, :collection, :unique_id, :updated_at, :name, :name_line_1, :name_line_2, :items

    def self.display(showcase, json)
      new(showcase).display(json)
    end

    def at_id
      h.v1_showcase_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def description
      object.description.to_s
    end

    def slug
      CreateURLSlug.call(object.slug)
    end

    def additional_type
      "https://github.com/ndlib/honeycomb/wiki/Showcase"
    end

    def next
      SiteObjectsQuery.new.next(collection_object: object)
    end

    def previous
      SiteObjectsQuery.new.previous(collection_object: object)
    end

    def sections
      SectionQuery.new(object.sections).ordered
    end

    def image
      if object.image
        object.image.json_response
      else
        nil
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
        json.name_line_1 name_line_1
        json.name_line_2 name_line_2
        json.description description
        json.image image
        json.last_updated updated_at
      end
    end
  end
end
