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
    configuration.fields.each do |field|
      if new_field_order[field.name]
        configuration.save_field(field.name, "order" => new_field_order[field.name])
      end
    end
  end
end
