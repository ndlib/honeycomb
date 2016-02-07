# Translates a hash of Item properties to their common property names
class RewriteItemMetadataForExport
  attr_reader :configuration, :label_map
  private :configuration, :label_map

  def initialize(configuration)
    @configuration = configuration
    @label_map = Hash[configuration.field_labels.map { |name| [name, nil] }]
  end

  def self.call(item_hash:, configuration:)
    new(configuration).rewrite(item_hash: item_hash)
  end

  def rewrite(item_hash:)
    result = Hash.new
    item_hash.each do |k, v|
      new_pair = rewrite_pair(key: k, value: v)
      result[new_pair.key] = new_pair.value
    end
    label_map.merge!(result)
  end

  private

  # Maps labels to field names and rewrites some value types
  # such as multiple value fields and date fields
  def rewrite_pair(key:, value:)
    key = key.to_sym
    result = OpenStruct.new(key: key, value: value)

    if configuration.field?(key)
      field = configuration.field(key)
      result.key = field.label
      if result.value.present?
        rewrite_values(field: field, pair: result)
      end
    end
    result
  end

  def rewrite_values(field:, pair:)
    if field.multiple
      pair.value = pair.value.join("||")
    end

    if field.type == :date
      pair.value = "'" + MetadataDate.from_hash(pair.value).to_string
    end
  end
end
