module Metadata
  class Retrieval
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def fields
      @fields ||= {}.tap do |hash|
        item.metadata.keys.each do |key|
          hash[key] = field(key)
        end
      end
    end

    def field(field)
      metadata_value(field)
    end

    def field?(field)
      get(field).present?
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(item.collection).find
    end

    def get(field)
      item.metadata[field.to_s]
    end

    def metadata_value(field)
      value = get(field)
      config = configuration.field(field)

      return nil if value.nil? || config.nil?

      type = config.type
      value = ensure_value_is_array(value)
      method = value_method(type)

      send(method, value)
    end

    def value_method(type)
      if type.to_sym == :string
        "string_value"
      elsif type.to_sym == :html
        "html_value"
      elsif type.to_sym == :date
        "date_value"
      else
        raise "missing type"
      end
    end

    def string_value(value)
      if value.is_a?(Array)
        value.map { |v| MetadataString.new(v) }
      else
        [MetadataString.new(value)]
      end
    end

    def html_value(value)
      if value.is_a?(Array)
        value.map { |v| MetadataHTML.new(v) }
      else
        [MetadataHTML.new(value)]
      end
    end

    def date_value(value)
      if value.is_a?(Array)
        value.map { |v| MetadataDate.new(v.symbolize_keys) }
      else
        [MetadataDate.new(value.symbolize_keys)]
      end
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
