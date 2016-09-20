class CollectionImage
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def display
    if collection.image
      Thumbnail.display(collection.image, "collection")
    elsif first_item_with_image
      Thumbnail.display(first_item_with_image.media, "collection")
    else
      ""
    end
  end

  private

  def first_item_with_image
    @first_item_with_image ||= collection.items.joins(:media).first
  end
end
