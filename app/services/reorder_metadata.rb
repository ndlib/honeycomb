class ReorderMetadata
  attr_reader :configuration

  def self.call(collection, new_field_order)
    new(collection).reorder(new_field_order)
  end

  def initialize(collection)
    @collection = collection
    @configuration = CollectionConfigurationQuery.new(@collection).find
  end

  def reorder(new_field_order)
    new_field_order.each do |_index, field|
      if configuration.field(field["name"])
        configuration.save_field(field["name"], "order" => field["order"].to_i)
      end
    end
  end
end
