module V1
  class ImageJSONDecorator < Draper::Decorator
    delegate :id, :collection, :image, :updated_at

    def self.display(image:, json:)
      new(image).display(json: json)
    end

    def at_context
      "http://schema.org"
    end

    def at_type
      "ImageObject"
    end

    def at_id
      url(style: :large)
    end

    def name
      object.image.original_filename
    end

    def status
      object.status
    end

    def encoding_format
      object.image.content_type
    end

    def url(style: :original)
      if object.json_response["thumbnail/#{style}"]
        object.json_response["thumbnail/#{style}"]["contentUrl"]
      else
        object.json_response["contentUrl"]
      end
    end

    def width(style: :original)
      "#{object.image.width(style)} px"
    end

    def height(style: :original)
      "#{object.image.height(style)} px"
    end

    def display(json:)
      if object.present?
        set_json_keys(json: json)
      end
    end

    def to_builder
      Jbuilder.new do |json|
        display(json: json)
      end
    end

    def to_json
      to_builder.target!
    end

    def to_hash
      JSON.parse(to_json)
    end

    private

    def honeypot_url
      Rails.configuration.settings.honeypot_url
    end

    def set_json_keys(json:)
      json.set! "@context", at_context
      json.set! "@id", at_id
      json.name name
      json.status status
      set_image_object_json_keys(json: json, style: :large)
      json.set! "thumbnail/small" do |json_small|
        set_image_object_json_keys(json: json_small, style: :small)
      end
      json.set! "thumbnail/medium" do |json_medium|
        set_image_object_json_keys(json: json_medium, style: :medium)
      end
    end

    def set_image_object_json_keys(json:, style:)
      json.set! "@type", at_type
      json.width width(style: style)
      json.height height(style: style)
      json.encodingFormat encoding_format
      json.contentUrl url(style: style)
    end
  end
end
