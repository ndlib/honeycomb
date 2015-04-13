@collection.display(json)
json.set! :showcases do
  json.array! @collection.showcases do |showcase|
    V1::ShowcaseJSONDecorator.display(showcase, json)
  end
end
