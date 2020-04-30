module Waggle
  module Search
    class SortField
      attr_reader :name, :value, :active, :order

      def self.from_config(sort_configuration)
        new(name: sort_configuration.label, value: sort_configuration.name, active: sort_configuration.active, order: sort_configuration.order)
      end

      def initialize(name:, value:, active: true, order: nil)
        @name = name
        @value = value
        @active = active
        @order = order
      end
    end
  end
end
