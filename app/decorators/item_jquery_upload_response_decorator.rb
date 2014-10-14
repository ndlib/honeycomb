class ItemJqueryUploadResponseDecorator  < Draper::Decorator
  delegate_all


  def to_json
    {
      "name" => object.image_file_name,
      "size" => object.image_file_size,
      "url" => object.image.url(:original),
      "delete_url" => h.collection_item_path(object.collection, object),
      "delete_type" => "DELETE"
    }
  end
end
