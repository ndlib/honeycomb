class CollectionImage
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def display
    if collection.image
      Thumbnail.display(collection.image, "item")
    elsif first_item_with_image
      Thumbnail.display(first_item_with_image.media, "item")
    else
      ""
    end
  end

  private

  def first_item_with_image
    @first_item_with_image ||= collection.items.joins(:media).first
  end
end
