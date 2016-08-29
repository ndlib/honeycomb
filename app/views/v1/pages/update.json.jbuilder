V1::CollectionJSONDecorator.display(@page.collection, json)
json.set! :pages do
  @page.display(json)
end
