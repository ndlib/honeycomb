class ProcessImageJob < ActiveJob::Base
  queue_as :honeypot_images

  def perform(object:, upload_field: "uploaded_image", image_field: "image")
    ProcessUploadedImage.call(object: object, upload_field: upload_field, image_field: image_field)
    SaveHoneypotImage.queue(object: object, image_field: image_field)
  end
end
