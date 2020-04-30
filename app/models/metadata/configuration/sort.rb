module Metadata
  class Configuration
    class Sort
      include ActiveModel::Validations

      attr_accessor :name, :field_name, :direction, :label, :active, :order
      attr_reader :field

      validates :name, :field_name, presence: true
      validates :order, numericality: { only_integer: true, allow_nil: true }

      def initialize(name:, field: nil, field_name:, direction: 'asc', label: nil, active: true, order: nil)
        @name = name
        @field = field
        @field_name = field_name
        @direction = direction
        @label = label
        @active = active
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
          direction: direction,
          label: label,
          active: active,
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
      end
    end
  end
end
