class SaveHoneypotImageJob < ActiveJob::Base
  queue_as :default

  def perform(object)
    SaveHoneypotImage.call(object)
  end
end
