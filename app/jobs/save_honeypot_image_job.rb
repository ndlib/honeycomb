class SaveHoneypotImageJob < ActiveJob::Base
  queue_as :honeypot_images

  def perform(object)
    SaveHoneypotImage.call(object)
  end
end
