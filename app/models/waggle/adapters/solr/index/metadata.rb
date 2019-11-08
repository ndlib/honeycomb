module Waggle
  module Adapters
    module Solr
      module Index
        class Metadata
          attr_reader :metadata_set
          private :metadata_set

          delegate :configuration, :value, :facet, :sort, to: :metadata_set

          def initialize(metadata_set:)
            @metadata_set = metadata_set
          end

          def as_solr
            {}.tap do |hash|
              hash.merge!(fields_as_solr)
              hash.merge!(facets_as_solr)
              hash.merge!(sorts_as_solr)
            end
          end

          private

          def fields_as_solr
            {}.tap do |hash|
              configuration.fields.each do |field|
                field_value = value(field.name)
                if field_value.present?
                  if field.type.to_s == "date"
                    hash[datetime_field_name(field.name)] = datetime_as_solr(field_value)
                  else
                    hash[text_field_name(field.name)] = text_as_solr(field_value)
                  end
                end
              end
            end
          end

          def facets_as_solr
            {}.tap do |hash|
              configuration.facets.each do |facet|
                facet_value = facet(facet.name)
                if facet_value.present?
                  hash[facet_field_name(facet.name)] = facet_as_solr(facet_value)
                end
              end
            end
          end

          def sorts_as_solr
            {}.tap do |hash|
              configuration.sorts.each do |sort|
                sort_value = sort(sort.name)
                if sort_value.present?
                  hash[sort_field_name(sort.field_name)] ||= sort_as_solr(sort_value)
                end
              end
            end
          end

          def datetime_field_name(name)
            Waggle::Adapters::Solr::Types::DateTime.field_name(name)
          end

          def datetime_as_solr(value)
            Waggle::Adapters::Solr::Types::DateTime.as_solr(value)
          end

          def text_field_name(name)
            Waggle::Adapters::Solr::Types::Text.field_name(name)
          end

          def text_as_solr(value)
            Waggle::Adapters::Solr::Types::Text.as_solr(value)
          end

          def facet_field_name(name)
            Waggle::Adapters::Solr::Types::Facet.field_name(name)
          end

          def facet_as_solr(value)
            Waggle::Adapters::Solr::Types::Facet.as_solr(value)
          end

          def sort_field_name(name)
            Waggle::Adapters::Solr::Types::Sort.field_name(name)
          end

          def sort_as_solr(value)
            Waggle::Adapters::Solr::Types::Sort.as_solr(value)
          end
        end
      end
    end
  end
end
