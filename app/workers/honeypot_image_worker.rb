require 'sneakers/handlers/maxretry'

class HoneypotImageWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  from_queue 'honeypot_images',
    handler: Sneakers::Handlers::Maxretry,
    workers: 1,
    threads: 1,
    timeout_job_after: 60,
    heartbeat_interval: 2
end
