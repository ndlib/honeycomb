class ProcessItemImageJob < ActiveJob::Base
  queue_as :honeypot_images

  def perform(item)
    ProcessUploadedImage.call(object: item)
    SaveHoneypotImage.queue(item)
  end
end
