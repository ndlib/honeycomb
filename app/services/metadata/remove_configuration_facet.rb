module Metadata
  class RemoveConfigurationFacet
    attr_reader :collection

    def self.call(collection, facet)
      new(collection).remove_facet(facet)
    end

    def initialize(collection)
      @collection = collection
    end

    def remove_facet(facet)
      configuration.save_facet(facet, nil)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
