require 'sneakers/handlers/maxretry'

class HoneypotImageWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  from_queue 'honeypot_images',
    handler: Sneakers::Handlers::Maxretry

end
