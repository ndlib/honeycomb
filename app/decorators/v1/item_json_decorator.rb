module V1
  class ItemJSONDecorator < Draper::Decorator
    delegate :id, :title, :children, :parent, :collection, :unique_id, :updated_at

    METADATA_MAP = [
      ['Title', :title],
      ['Description', :description],
      ['Manuscript', :manuscript_url],
      ['Transcript', :transcription]
    ]

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

    def transcription
      object.transcription.to_s
    end

    def slug
      CreateURLSlug.call(object.title)
    end

    def image
      if object.honeypot_image
        object.honeypot_image.json_response
      else
        nil
      end
    end

    def metadata
      [].tap do |array|
        METADATA_MAP.each do |label, field|
          value = metadata_value(field)
          if value
            array << {label: label, value: value}
          end
        end
      end
    end

    def display(json)
      if self.present?
        json.partial! '/v1/items/item', item_object: self
      end
    end

    private
      def metadata_value(field)
        value = object.send(field)
        if value.present?
          value
        else
          nil
        end
      end
  end
end
