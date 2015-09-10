module Waggle
  module Adapters
    module Sunspot
      module Index
        module Indexer
          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
            def index_class
              raise "index_class not implemented"
            end

            def setup_index(&block)
              ::Sunspot.setup(index_class) do
                instance_eval &block
              end
            end

            def reset!
              ::Sunspot::Setup.send(:setups)[index_class.name.to_sym] = nil
            end
          end
        end
      end
    end
  end
end
