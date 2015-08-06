module Waggle
  module Adapters
    module Sunspot
      module Index
        module Item
          def self.setup(configuration = default_configuration) # rubocop:disable Metrics/AbcSize
            reset!
            ::Sunspot.setup(Waggle::Item) do
              configuration.fields.each do |field|
                if field.type == :date
                  time field.name, multiple: true
                elsif [:string, :html].include?(field.type)
                  text field.name
                else
                  raise "unknown type #{field.type}"
                end
              end
              string :collection_id, stored: true
              string :type, stored: true
              string :thumbnail_url, stored: true
              time :last_updated, stored: true
              text :name, stored: true
            end
          end

          def self.reset!
            ::Sunspot::Setup.send(:setups)[Waggle::Item.name.to_sym] = nil
          end

          def self.default_configuration
            ::Metadata::Configuration.item_configuration
          end
        end
      end
    end
  end
end
