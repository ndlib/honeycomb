module Metadata
  class UpdateConfigurationFacet
    attr_reader :collection

    def self.call(collection, facet, new_data)
      new(collection).update_facet(facet, new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def update_facet(facet, new_data)
      new_data = ConfigurationInputCleaner.call(new_data)
      new_data[:name] = new_data[:field_name]
      if new_data[:unlimited].present?
        new_data.delete(:unlimited)
      end
      configuration.save_facet(facet, new_data)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
