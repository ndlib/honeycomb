module Waggle
  module Adapters
    module Solr
      module Search
        class Facet
          attr_reader :facet_rows, :facet_config
          private :facet_rows, :facet_config

          def initialize(facet_rows:, facet_config:)
            @facet_rows = facet_rows
            @facet_config = facet_config
          end

          def name
            facet_config.label
          end

          def field
            facet_config.name
          end

          def active
            facet_config.active
          end

          def values
            @values ||= facet_rows.each_slice(2).map { |row| Waggle::Adapters::Solr::Search::FacetValue.new(row) }
          end

          def order
            facet_config.order
          end
        end
      end
    end
  end
end
