class ProcessItemImageJob < ActiveJob::Base
  queue_as :honeypot_images

  def perform(item)
    ProcessItemUploadedImage.call(item)
    SaveHoneypotImage.queue(item)
  end
end
