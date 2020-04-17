module Metadata
  class Configuration
    class Facet
      include ActiveModel::Validations

      attr_accessor :name, :field_name, :label, :active, :limit, :order
      attr_reader :field

      validates :name, :field_name, presence: true
      validates :limit, :order, numericality: { only_integer: true, allow_nil: true }

      def initialize(name:, field: nil, field_name:, label: nil, active: true, limit: 5, order: nil)
        @name = name
        @field = field
        @field_name = field_name
        @label = label
        @active = active
        @limit = limit
        @order = order
        validate
      end

      def label
        @label || (field ? field.label : nil)
      end

      def to_hash
        {
          name: name,
          field: field,
          field_name: field_name,
          label: label,
          active: active,
          limit: limit,
          order: order,
        }
      end

      def update(new_attributes)
        convert_json_to_ruby_keys!(new_attributes)

        # remove attributes that are readonly or not persisted to database
        if name.present?
          new_attributes.delete(:name)
        end
        if field.present?
          new_attributes.delete(:field)
        end

        new_attributes.each do |key, value|
          send("#{key}=", value)
        end
        valid?
      end

      private

      def convert_json_to_ruby_keys!(hash)
        hash.to_hash.symbolize_keys!

        convert_strings_to_booleans([:active], hash)
      end

      def convert_strings_to_booleans(keys, hash)
        keys.each do |key|
          case hash[key]
          when "true"
            hash[key] = true
          when "false"
            hash[key] = false
          end
        end
      end
    end
  end
end
