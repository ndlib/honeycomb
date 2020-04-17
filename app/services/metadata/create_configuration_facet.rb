module Metadata
  class CreateConfigurationFacet
    attr_reader :collection

    def self.call(collection, new_data)
      new(collection).create_facet(new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def create_facet(new_data)
      populate_defaults(values: new_data)
      new_data = ConfigurationInputCleaner.call(new_data)
      # Name for facet should always match field name
      new_data[:name] = new_data[:field_name]
      if new_data[:unlimited].present?
        new_data.delete(:unlimited)
      end

      if duplicate_name?(new_data)
        return nil
      else
        configuration.save_facet(new_data[:name], new_data)
      end
    end

    private

    # Populates default values for when there are no values given,
    # since we can't do it at the database layer
    def populate_defaults(values:)
      if values[:limit].nil? || values[:limit] == ""
        values[:limit] = 5
      end

      if values[:active].nil? || values[:active] == ""
        values[:active] = true
      end
    end

    def duplicate_name?(new_data)
      duplicates = @collection.collection_configuration.facets.select do |f|
        h = f.with_indifferent_access
        h[:name].casecmp(new_data[:name]) == 0
      end
      duplicates.count >= 1 ? true : false
    end

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
