module Metadata
  class UpdateConfigurationSort
    attr_reader :collection

    def self.call(collection, sort, new_data)
      new(collection).update_sort(sort, new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def update_sort(sort, new_data)
      new_data = ConfigurationInputCleaner.call(new_data)
      configuration.save_sort(sort, new_data)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
