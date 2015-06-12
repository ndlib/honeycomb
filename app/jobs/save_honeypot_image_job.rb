class SaveHoneypotImageJob < ActiveJob::Base
  queue_as :honeypot_images

  def perform(object:, image_field: "image")
    SaveHoneypotImage.call(object: object, image_field: image_field)
  end
end
