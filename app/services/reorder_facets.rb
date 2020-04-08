class ReorderFacets
  attr_reader :configuration

  def self.call(collection, new_facet_order)
    new(collection).reorder(new_facet_order)
  end

  def initialize(collection)
    @collection = collection
    @configuration = CollectionConfigurationQuery.new(@collection).find
  end

  def reorder(new_facet_order)
    new_facet_order.each do |_index, facet|
      if configuration.facet(facet['name'])
        configuration.save_facet(facet['name'], 'order' => facet['order'].to_i)
      end
    end
  end
end
