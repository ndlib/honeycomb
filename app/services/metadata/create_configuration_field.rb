module Metadata
  class CreateConfigurationField
    attr_reader :collection

    def self.call(collection, new_data)
      new(collection).create_field(new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def create_field(new_data)
      populate_defaults(values: new_data)
      new_data = ConfigurationInputCleaner.call(new_data)

      if duplicate_label?(new_data)
        return nil
      else
        unique_key = Metadata::GenerateUniqueKey.call
        new_data[:name] = unique_key
        configuration.save_field(unique_key, new_data)
      end
    end

    private

    # Populates default values for some fields when there are no values given,
    # since we can't do it at the database layer
    def populate_defaults(values:)
      if values[:order].nil? || values[:order] == ""
        max = CollectionConfigurationQuery.new(collection).max_metadata_order
        values[:order] = max + 1
      end

      if values[:active].nil? || values[:active] == ""
        values[:active] = true
      end
    end

    def duplicate_label?(new_data)
      duplicates = @collection.collection_configuration.metadata.select do |m|
        h = m.with_indifferent_access
        h[:label].casecmp(new_data[:label]) == 0
      end
      duplicates.count >= 1 ? true : false
    end

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
