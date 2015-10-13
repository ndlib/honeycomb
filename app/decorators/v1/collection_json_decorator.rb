
module V1
  class CollectionJSONDecorator < Draper::Decorator
    delegate :id, :unique_id, :updated_at, :name, :name_line_1, :name_line_2

    def self.display(collection, json)
      new(collection).display(json)
    end

    def at_id
      h.v1_collection_url(object.unique_id)
    end

    def items_url
      h.v1_collection_items_url(object.unique_id)
    end

    def showcases_url
      h.v1_collection_showcases_url(object.unique_id)
    end

    def metadata_configuration_url
      h.v1_collection_metadata_configuration_url(object.unique_id)
    end

    def external_url
      object.exhibit.url ? object.exhibit.url : ""
    end

    def additional_type
      object.exhibit.url ? "https://github.com/ndlib/honeycomb/wiki/ExternalCollection" : "https://github.com/ndlib/honeycomb/wiki/DecCollection"
    end

    def description
      object.description.to_s
    end

    def enable_search
      !!object.exhibit.enable_search
    end

    def enable_browse
      !!object.exhibit.enable_browse
    end

    def site_intro
      object.exhibit.description.to_s
    end

    def short_intro
      object.exhibit.short_description.to_s
    end

    def about
      object.about.to_s
    end

    def copyright
      exhibit_copyright = object.exhibit.copyright.to_s
      if exhibit_copyright.empty?
        "<p><a href=\"http://www.nd.edu/copyright/\">Copyright</a> #{Date.today.year} <a href=\"http://www.nd.edu\">University of Notre Dame</a></p>"
      else
        exhibit_copyright
      end
    end

    def display_page_title
      !object.exhibit.hide_title_on_home_page?
    end

    def slug
      CreateURLSlug.call(object.name_line_1)
    end

    def items
      @items ||= ItemQuery.new(object.items).only_top_level
    end

    def showcases
      @showcases ||= ShowcaseQuery.new(object.showcases).public_api_list
    end

    def image
      if object.exhibit.honeypot_image
        object.exhibit.honeypot_image.json_response
      else
        nil
      end
    end

    def display(json, _includes = {})
      json.partial! "/v1/collections/collection", collection_object: self
end
  end
end
