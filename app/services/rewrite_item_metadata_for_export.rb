# Translates a hash of Item properties to their common property names
class RewriteItemMetadataForExport
  attr_reader :configuration
  private :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def self.call(user_defined_id:, parent_user_defined_id:, item_hash:, configuration:)
    new(configuration).rewrite(user_defined_id: user_defined_id, parent_user_defined_id: parent_user_defined_id, item_hash: item_hash)
  end

  def rewrite(user_defined_id:, parent_user_defined_id:, item_hash:)
    # First make a map of all labels, otherwise the result will only include those that have values
    label_map = Hash[configuration.field_labels.map { |name| [name, nil] }]

    item_values = Hash.new
    item_hash.each do |k, v|
      new_pair = rewrite_pair(key: k, value: v)
      item_values[new_pair.key] = new_pair.value
    end
    label_map.merge!(item_values)
    label_map = { "Parent Identifier" => parent_user_defined_id }.merge(label_map)
    label_map = { "Identifier" => user_defined_id }.merge(label_map)
    label_map
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
    else
      pair.value = pair.value.first
    end

    if field.type == :date
      pair.value = Metadata::Fields::DateField.from_hash(pair.value).to_string
    end
  end
end
