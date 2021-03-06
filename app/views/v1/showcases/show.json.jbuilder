V1::CollectionJSONDecorator.display(@showcase.collection, json)
json.set! :showcases do
  @showcase.display(json)
  json.set! :nextObject do
    V1::SiteObjectsJSONDecorator.display(@showcase.next, json) if @showcase.next.present?
  end
  json.set! :previousObject do
    V1::SiteObjectsJSONDecorator.display(@showcase.previous, json) if @showcase.previous.present?
  end
  json.set! :sections do
    json.array! @showcase.sections do |section|
      V1::SectionJSONDecorator.display(section, json)
      json.set! :item do
        V1::ItemJSONDecorator.display(section.item, json)
      end
    end
  end
end
