module Metadata
  class Configuration
    class Facet
      attr_reader :field, :field_name, :name, :active, :limit

      def initialize(name:, field:, field_name:, label: nil, active: true, limit: nil)
        @name = name
        @field = field
        @field_name = field_name
        @label = label
        @active = active
        @limit = limit
      end

      def label
        @label || field.label
      end
    end
  end
end
