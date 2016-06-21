class ProcessImageJob < ActiveJob::Base
  queue_as :uploaded_images

  def perform(object:, upload_field: "uploaded_image", image_field: "image")
    QueueJob.call(SaveHoneypotImageJob, object: object, image_field: image_field)
  end
end
