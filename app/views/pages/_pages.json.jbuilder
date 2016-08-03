json.array! @item.pages do |page|
  V1::PageJSONDecorator.display(page, json)
end
