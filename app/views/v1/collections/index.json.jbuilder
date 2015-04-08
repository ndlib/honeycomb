json.array!(@collections) do |collection|

  V1::CollectionJSONDecorator.display(collection, json)

end
