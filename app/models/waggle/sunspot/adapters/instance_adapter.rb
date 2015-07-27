module Waggle
  module Sunspot
    module Adapters
      class InstanceAdapter < ::Sunspot::Adapters::InstanceAdapter
        def id
          @instance.id
        end
      end
    end
  end
end
