# Translates a hash of common property names to valid Item properties
class RewriteItemMetadata
  attr_reader :configuration, :field_map
  private :configuration, :field_map

  def initialize(configuration)
    @configuration = configuration
    @field_map = Hash[configuration.field_names.map { |name| [name, nil] }]
  end

  def self.call(item_hash:, errors:, configuration:)
    new(configuration).rewrite(item_hash: item_hash, errors: errors)
  end

  def rewrite(item_hash:, errors:)
    result = Hash.new
    item_hash.each do |k, v|
      new_pair = rewrite_pair(key: k, value: v)
      if Item.method_defined?(new_pair.key)
        result[new_pair.key] = new_pair.value
      else
        errors << "Unknown attribute #{k}"
      end
    end
    field_map.merge!(result)
  end

  private

  # Maps labels to field names and rewrites some value types
  # such as multiple value fields and date fields
  def rewrite_pair(key:, value:)
    result = OpenStruct.new(key: key.to_sym, value: value)
    if configuration.label?(key)
      field = configuration.label(key)
      result.key = field.name
      if result.value.present?
        rewrite_values(field: field, pair: result)
      end
    end
    result
  end

  def rewrite_values(field:, pair:)
    if field.multiple
      pair.value = pair.value.split("||")
    end

    if field.type == :date
      pair.value = MetadataDate.parse(pair.value).to_params
    end
  end
end
