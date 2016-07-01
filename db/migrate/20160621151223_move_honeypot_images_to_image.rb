class MoveHoneypotImagesToImage < ActiveRecord::Migration
  def up
    Collection.all.each do |collection|
      make_image_from_object(object: collection, collection_id: collection.id)
    end

    Showcase.all.each do |showcase|
      make_image_from_object(object: showcase, collection_id: showcase.collection_id)
    end

    Item.where.not(image_status: 0).each do |item|
      image = make_image_from_object(object: item, collection_id: item.collection_id)
      image.status = Item.image_statuses[item.image_status]
      image.save
    end
  end

  def make_image_from_object(object:, collection_id:)
    object_image = object.image
    status = "ready"
    # If an image is stuck in processing for some reason when we do this migration,
    # the actual image will be in uploaded_image, not image
    unless object.image.file?
      object_image = object.uploaded_image
    end
    return nil unless object_image.file?
    unless object_image.exists?
      pp "Could not find file #{object_image.path} for #{object.model_name.name} #{object.id}."
      return nil
    end
    file = File.new(object_image.path)
    image = FindOrCreateImage.call(file: file, collection_id: collection_id)
    raise "Could not create image using #{object_image.path} for #{object.model_name.name} #{object.id}\n" unless image
    image.json_response = object.honeypot_image.json_response if object.honeypot_image
    image.status = status
    image.save
    object.image_id = image.id
    object.save
    file.close
    image
  end
end

class Collection < ActiveRecord::Base
  has_one :honeypot_image
  has_attached_file :image
  has_attached_file :uploaded_image
end

class Item < ActiveRecord::Base
  has_one :honeypot_image
  has_attached_file :image
  has_attached_file :uploaded_image
  enum image_status: { no_image: 0, image_processing: 1, image_ready: 2, image_unavailable: 3 }
end

class Showcase < ActiveRecord::Base
  has_one :honeypot_image
  has_attached_file :image
  has_attached_file :uploaded_image
end

class HoneypotImage < ActiveRecord::Base
end

class Image < ActiveRecord::Base
  belongs_to :collection
  has_attached_file :image

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :collection, presence: true

  enum status: { unprocessed: 0, processing: 1, ready: 2, unavailable: 3 }

  has_paper_trail
end

class FindOrCreateImage
  attr_reader :file, :collection_id

  def self.call(file:, collection_id:)
    new(file: file, collection_id: collection_id).find_or_create
  end

  def initialize(file:, collection_id:)
    @file = file
    @collection_id = collection_id
  end

  def find_or_create
    # Not sure if there is a simpler way to get paperclip to generate the fingerprint without creating a new Image
    # and processing all of the styles
    new_image = Image.new(image: file, collection_id: collection_id)
    found_image = Image.where(collection_id: collection_id, image_fingerprint: new_image.image_fingerprint).take
    image = found_image.nil? ? new_image : found_image
    if image.save
      image
    else
      false
    end
  end
end
