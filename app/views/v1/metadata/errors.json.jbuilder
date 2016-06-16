# Display item with errors
V1::ItemJSONDecorator.display(@item, json)
json.set! "errors", @item.item_metadata.errors
