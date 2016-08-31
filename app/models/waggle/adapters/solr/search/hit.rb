module Waggle
  module Adapters
    module Solr
      module Search
        class Hit
          attr_reader :solr_doc
          private :solr_doc

          def initialize(solr_doc)
            @solr_doc = solr_doc
          end

          def id
            fetch(:id)
          end

          def name
            fetch_text(:name)
          end

          def at_id
            fetch_string(:at_id)
          end

          def unique_id
            fetch_string(:unique_id)
          end

          def collection_id
            fetch_string(:collection_id)
          end

          def type
            fetch_string(:type)
          end

          def thumbnail_url
            fetch_string(:thumbnail_url)
          end

          def last_updated
            fetch_datetime(:last_updated)
          end

          def description
            fetch_text(:description)
          end

          def creator
            fetch_text(:creator)
          end

          def date_created
            fetch_text(:date_created)
          end

          private

          def fetch_text(field)
            fetch(Waggle::Adapters::Solr::Types::Text.field_name(field))
          end

          def fetch_string(field)
            fetch(Waggle::Adapters::Solr::Types::String.field_name(field))
          end

          def fetch_datetime(field)
            value = fetch(Waggle::Adapters::Solr::Types::DateTime.field_name(field))
            if value.present?
              Waggle::Adapters::Solr::Types::DateTime.from_solr(value)
            end
          end

          def fetch(field)
            value = solr_doc.fetch(field.to_s, nil)
            if value.is_a?(Array)
              value.first
            else
              value
            end
          end
        end
      end
    end
  end
end
