module Metadata
  class CreateConfigurationSort
    attr_reader :collection

    def self.call(collection, new_data)
      new(collection).create_sort(new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def create_sort(new_data)
      populate_defaults(values: new_data)
      new_data = ConfigurationInputCleaner.call(new_data)
      new_data[:name] = new_data[:field_name]

      # If name already exists, try appending the sort direction.
      if duplicate?(new_data)
        new_data[:name] = new_data[:name] + '_' + new_data[:direction]
      end

      # Check if still a duplicate
      if duplicate?(new_data)
        return nil
      else
        configuration.save_sort(new_data[:name], new_data)
      end
    end

    private

    # Populates default values for when there are no values given,
    # since we can't do it at the database layer
    def populate_defaults(values:)
      if values[:active].nil? || values[:active] == ""
        values[:active] = true
      end
    end

    def duplicate?(new_data)
      duplicates = @collection.collection_configuration.sorts.select do |s|
        h = s.with_indifferent_access
        (h[:field_name].casecmp(new_data[:field_name]) == 0 && h[:direction].casecmp(new_data[:direction]) == 0) || h[:name].casecmp(new_data[:name]) == 0
      end
      duplicates.count >= 1 ? true : false
    end

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
