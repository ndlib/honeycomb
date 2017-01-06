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
    metadata = Hash.new
    item_hash.each do |k, v|
      case k
      when "Parent Identifier"
        if v.present?
          parent = Item.where(user_defined_id: v).take
          if parent.present?
            result[:parent_id] = parent.id
          else
            errors << "Unable to find parent item '#{v}'"
          end
        else
          # Since this label was explicitly defined with a nil value, we have to
          # insert a parent_id of nil to clear any existing association
          result[:parent_id] = nil
        end
      when "Identifier"
        result[:user_defined_id] = v
      else
        new_pair = rewrite_pair(key: k, value: v)
        if configuration.field?(new_pair.key) || new_pair.key == "user_defined_id"
          metadata[new_pair.key] = new_pair.value
        else
          errors << "Unknown attribute #{k}"
        end
      end
    end
    result[:metadata] = field_map.merge!(metadata)
    result
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
      pair.value = Metadata::Fields::DateField.parse(pair.value).to_params
    end
  end
end
