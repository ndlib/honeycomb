class ReorderSorts
  attr_reader :configuration

  def self.call(collection, new_sort_order)
    new(collection).reorder(new_sort_order)
  end

  def initialize(collection)
    @collection = collection
    @configuration = CollectionConfigurationQuery.new(@collection).find
  end

  def reorder(new_sort_order)
    new_sort_order.each do |_index, sort|
      if configuration.sort(sort['name'])
        configuration.save_sort(sort['name'], 'order' => sort['order'].to_i)
      end
    end
  end
end
