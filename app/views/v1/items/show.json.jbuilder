V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  V1::ItemJSONDecorator.display(@item, json)
end
