
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
      h.v1_collection_configurations_url(object.unique_id)
    end

    def external_url
      object.url ? object.url : ""
    end

    def additional_type
      object.url ? "https://github.com/ndlib/honeycomb/wiki/ExternalCollection" : "https://github.com/ndlib/honeycomb/wiki/DecCollection"
    end

    def description
      object.description.to_s
    end

    def enable_search
      !!object.enable_search
    end

    def enable_browse
      !!object.enable_browse
    end

    def site_intro
      object.site_intro.to_s
    end

    def short_intro
      object.short_intro.to_s
    end

    def about
      object.about.to_s
    end

    def copyright
      collection_copyright = object.copyright.to_s
      if collection_copyright.empty?
        "<p><a href=\"http://www.nd.edu/copyright/\">Copyright</a> #{Date.today.year} <a href=\"http://www.nd.edu\">University of Notre Dame</a></p>"
      else
        collection_copyright
      end
    end

    def display_page_title
      !object.hide_title_on_home_page?
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

    def pages
      @pages ||= PageQuery.new(object.pages).ordered
    end

    def image
      if object.honeypot_image
        object.honeypot_image.json_response
      end
    end

    def display(json, _includes = {})
      json.partial! "/v1/collections/collection", collection_object: self
    end
  end
end
