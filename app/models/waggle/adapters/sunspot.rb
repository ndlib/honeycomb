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

      def self.remove(*objects)
        ::Sunspot.remove(*objects)
      end

      def self.remove!(*objects)
        ::Sunspot.remove!(*objects)
      end

      def self.commit
        ::Sunspot.commit
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
      private_class_method :register_sunspot_adapters

      def self.setup_indexers
        self::Index::Item.setup
      end
      private_class_method :setup_indexers
    end
  end
end
