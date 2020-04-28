module Metadata
  class Configuration
    class Field
      include ActiveModel::Validations
      TYPES = [:string, :html, :date]

      attr_accessor :name, :active, :type, :label, :multiple, :required, :default_form_field,
                    :optional_form_field, :order, :hidden, :placeholder, :help, :boost, :immutable,
                    :fieldSearch

      validates :name, :type, :label, :order, presence: true
      validates :order, :boost, numericality: { only_integer: true }
      validates :type, inclusion: TYPES

      def initialize(
        name: "",
        active: true,
        type: "",
        label: "",
        default_form_field: false,
        optional_form_field: false,
        boost: 1,
        order: 0,
        hidden: false,
        help: "",
        placeholder: "",
        multiple: false,
        required: false,
        immutable: ["name"],
        fieldSearch: true
      )
        if hidden.nil?
          hidden = false
        end
        @name = name.to_sym
        @active = active
        @type = type.to_sym
        @label = label
        @multiple = multiple
        @required = required
        @hidden = hidden
        @default_form_field = default_form_field
        @optional_form_field = optional_form_field
        @order = order
        @placeholder = placeholder
        @help = help
        @boost = boost
        @immutable = immutable
        @fieldSearch = fieldSearch
        validate
      end

      def as_json(options = {})
        json = super
        convert_keys_to_json!(json)

        json
      end

      def to_hash
        {
          name: name,
          active: active,
          type: type,
          label: label,
          multiple: multiple,
          required: required,
          default_form_field: default_form_field,
          optional_form_field: optional_form_field,
          order: order,
          hidden: hidden,
          placeholder: placeholder,
          help: help,
          boost: boost,
          immutable: immutable,
          fieldSearch: fieldSearch,
        }
      end

      def update(new_attributes)
        if name.present?
          new_attributes.delete(:name)
        end
        convert_json_to_ruby_keys!(new_attributes)

        if new_attributes.has_key?(:immutable)
          new_attributes[:immutable].delete("immutable")
          new_attributes[:immutable].delete(:immutable)
          send("immutable=", new_attributes[:immutable])
        end

        new_attributes.each do |key, value|
          send("#{key}=", value) unless key == :immutable || immutable.include?(key.to_s)
        end
        valid?
      end

      private

      def convert_keys_to_json!(json)
        json["defaultFormField"] = json.delete("default_form_field")
        json["optionalFormField"] = json.delete("optional_form_field")
      end

      def convert_json_to_ruby_keys!(hash)
        hash.to_hash.symbolize_keys!
        hash[:type] = hash[:type].to_sym if hash[:type]
        hash[:default_form_field] = hash.delete(:defaultFormField) if hash[:defaultFormField]
        hash[:optional_form_field] = hash.delete(:optionalFormField) if hash[:optionalFormField]

        convert_strings_to_booleans([:multiple, :required, :default_form_field, :optional_form_field, :active, :fieldSearch], hash)
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
