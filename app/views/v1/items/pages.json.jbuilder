V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  V1::ItemJSONDecorator.display(@item, json)

  json.set! :pages do
    json.array! @item.pages do |page|
      V1::PageJSONDecorator.display(page, json)
    end
  end
end
