module Waggle
  module Adapters
    module Solr
      module Index
        class Item
          attr_reader :waggle_item
          private :waggle_item

          def initialize(waggle_item:)
            @waggle_item = waggle_item
          end

          def id
            "#{waggle_item.collection_id} #{waggle_item.id}"
          end

          def metadata
            @metadata ||= Waggle::Adapters::Solr::Index::Metadata.new(metadata_set: waggle_item.metadata)
          end

          def as_solr
            @as_solr = metadata.as_solr.clone.tap do |hash|
              hash[:id] = id
              hash[text_field_name(:title)] = hash.fetch(text_field_name(:name))
              hash.merge!(string_fields)
              hash.merge!(datetime_fields)
            end
            if waggle_item.children && !waggle_item.children.empty?
              @as_solr[:_childDocuments_] = children_field
            end
            @as_solr[:last_updated_sort] = datetime_as_solr(waggle_item.send(:last_updated))
            @as_solr
          end

          private

          def children_field
            children = []
            waggle_item.children.each do |child|
              waggle_child = Waggle::Adapters::Solr::Index::Item.new(waggle_item: Waggle::Item.from_item(child))
              children << waggle_child.as_solr
            end
            children
          end

          def string_fields
            {}.tap do |hash|
              [
                :at_id,
                :unique_id,
                :collection_id,
                :type,
                :thumbnail_url,
                :is_parent,
              ].each do |field|
                hash[string_field_name(field)] = string_as_solr(waggle_item.send(field))
              end
            end
          end

          def datetime_fields
            {}.tap do |hash|
              [
                :last_updated
              ].each do |field|
                hash[datetime_field_name(field)] = datetime_as_solr(waggle_item.send(field))
              end
            end
          end

          def text_field_name(name)
            Waggle::Adapters::Solr::Types::Text.field_name(name)
          end

          def string_field_name(name)
            Waggle::Adapters::Solr::Types::String.field_name(name)
          end

          def string_as_solr(value)
            Waggle::Adapters::Solr::Types::String.as_solr(value)
          end

          def datetime_field_name(name)
            Waggle::Adapters::Solr::Types::DateTime.field_name(name)
          end

          def datetime_as_solr(value)
            Waggle::Adapters::Solr::Types::DateTime.as_solr(value)
          end
        end
      end
    end
  end
end
