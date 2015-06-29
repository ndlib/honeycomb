module V1
  class MetadataJSON < Draper::Decorator
    delegate :name, :creator, :alternate_name, :publisher, :rights, :original_language, :manuscript_url

    def self.metadata(item)
      new(item).metadata
    end

    METADATA_MAP = [
      ["Name", :name],
      ["Description", :description],
      ["Manuscript", :manuscript_url],
      ["Transcription", :transcription],
      ["Creator", :creator],
      ["Alternate Name", :alternate_name],
      ["Publisher", :publisher],
      ["Rights", :rights],
      ["Original", :original_language],
      ["Date Created", :date_created],
      ["Date Published", :date_published],
      ["Date Modified", :date_modified],
    ]

    def metadata
      [].tap do |array|
        METADATA_MAP.each do |label, field|
          value = metadata_value(field)
          if value
            array << { label: label, value: value }
          end
        end
      end
    end

    def description
      object.description.to_s
    end

    def transcription
      object.transcription.to_s
    end

    def date_created
      return nil if !object.date_created
      MetadataDate.new(object.date_created).display_text
    end

    def date_modified
      return nil if !object.date_modified
      MetadataDate.new(object.date_modified).display_text
    end

    def date_published
      return nil if !object.date_published
      MetadataDate.new(object.date_published).display_text
    end

    private

    def metadata_value(field)
      value = self.send(field)
      if value.present?
        value
      else
        nil
      end
    end
  end
end
