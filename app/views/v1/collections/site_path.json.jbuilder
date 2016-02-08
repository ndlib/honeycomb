@collection.display(json)
json.set! :site_path do
  json.array! @site_path do |site_object|
    V1::SiteObjectsJSONDecorator.display(site_object, json)
  end
end
