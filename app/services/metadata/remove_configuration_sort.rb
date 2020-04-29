module Metadata
  class RemoveConfigurationSort
    attr_reader :collection

    def self.call(collection, sort)
      new(collection).remove_sort(sort)
    end

    def initialize(collection)
      @collection = collection
    end

    def remove_sort(sort)
      configuration.save_sort(sort, nil)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
