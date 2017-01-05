V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  V1::ItemJSONDecorator.display(@item, json)

  json.set! :children do
    json.array! @item.children do |child|
      V1::ItemJSONDecorator.display(child, json)
    end
  end
end
