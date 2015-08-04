module V1
  class MetadataJSON < Draper::Decorator
    delegate :name, :creator, :alternate_name, :publisher, :rights, :original_language, :manuscript_url

    def self.metadata(item)
      new(item).metadata
    end

    def metadata
      {}.tap do |hash|
        configuration.fields.each do |field_config|
          value = metadata_value(field_config.name)

          if value.present?
            hash[field_config.name] = field_hash(value, field_config)
          end
        end
      end
    end

    private

    def configuration
      Metadata::Configuration.item_configuration
    end

    def field_hash(value, field_config)
      {
        "@type" => "MetadataField",
        "name" => field_config.name,
        "label" => field_config.label,
        "values" => metadata_hash(field_config.type, value),
      }
    end

    def metadata_value(field)
      value = object.send(field)

      if value.present?
        ensure_value_is_array(value)
      end
    end

    def metadata_hash(type, value)
      if type == :string
        string_value(value)
      elsif type == :html
        html_value(value)
      elsif type == :date
        date_value(value)
      else
        raise "missing type"
      end
    end

    def string_value(value)
      value.map { |v| MetadataString.new(v).to_hash }
    end

    def html_value(value)
      value.map { |v| MetadataHTML.new(v).to_hash }
    end

    def date_value(value)
      value.map { |v| MetadataDate.from_hash(v).to_hash }
    end

    def ensure_value_is_array(value)
      if value.is_a?(Array)
        value
      else
        [value]
      end
    end
  end
end
