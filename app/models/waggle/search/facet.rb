module Waggle
  module Search
    class Facet
      attr_reader :name, :field, :values, :order

      def initialize(name:, field:, values:, order: nil)
        @name = name
        @field = field
        @values = values || []
        @order = order
      end
    end
  end
end
