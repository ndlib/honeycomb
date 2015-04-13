
module V1
  class ShowcaseJSONDecorator < Draper::Decorator
    delegate :id, :title, :description, :collection, :unique_id, :updated_at

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
      CreateURLSlug.call(object.title)
    end

    def sections
      SectionQuery.new(object.sections).all_in_showcase
    end

    def image
      if object.honeypot_image
        object.honeypot_image.json_response
      else
        nil
      end
    end

    def display(json)
      json.partial! '/v1/showcases/showcase', showcase_object: self
    end
  end
end
