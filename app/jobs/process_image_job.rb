class ProcessImageJob < ActiveJob::Base
  queue_as :uploaded_images

  def perform(object:, upload_field: "uploaded_image", image_field: "image", timestamp: DateTime.now)
    ProcessUploadedImage.call(object: object, upload_field: upload_field, image_field: image_field)
    QueueJob.call(SaveHoneypotImageJob, object: object, image_field: image_field)
  end
end
