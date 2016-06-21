class CollectionImage
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def display
    if collection.image
      HoneypotThumbnail.display(collection.image)
    elsif first_item_with_image
      HoneypotThumbnail.display(first_item_with_image.image)
    else
      ""
    end
  end

  private

  def first_item_with_image
    @first_item_with_image ||= collection.items.joins(:image).first
  end
end
