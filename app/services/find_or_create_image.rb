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
    new_image = Image.new(image: file, collection_id: collection_id, status: "processing", json_response: {})
    found_image = Image.where("collection_id = ? AND data->>'image_fingerprint' = ?", collection_id, new_image.image_fingerprint).take

    if found_image.nil?
      if new_image.save && process_image(image: new_image)
        new_image
      else
        false
      end
    else
      process_image(image: found_image)
      found_image
    end
  end

  def process_image(image:)
    QueueJob.call(SaveHoneypotImageJob, object: image, image_field: "image")
  rescue Bunny::TCPConnectionFailedForAllHosts
    image.unavailable!
  end
end
