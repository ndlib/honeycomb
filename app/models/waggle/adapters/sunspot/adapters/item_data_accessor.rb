module Waggle
  module Adapters
    module Sunspot
      module Adapters
        class ItemDataAccessor < ::Sunspot::Adapters::DataAccessor
          def load(id)
            @clazz.load(id)
          end
        end
      end
    end
  end
end
