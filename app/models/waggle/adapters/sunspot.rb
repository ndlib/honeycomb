module Waggle
  module Adapters
    module Sunspot
      def self.setup
        if !@setup
          register_sunspot_adapters
          setup_indexers
          @setup = true
        end
      end

      def self.index(*objects)
        ::Sunspot.index(*objects)
      end

      def self.index!(*objects)
        ::Sunspot.index!(*objects)
      end

      def self.register_sunspot_adapters
        ::Sunspot::Adapters::InstanceAdapter.register(
          self::Adapters::InstanceAdapter,
          Waggle::Item
        )
        ::Sunspot::Adapters::DataAccessor.register(
          self::Adapters::ItemDataAccessor,
          Waggle::Item
        )
      end

      def self.setup_indexers
        self::Index::Item.setup
      end
    end
  end
end
