require 'sneakers/handlers/maxretry'

class HoneypotImageWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  from_queue 'honeypot_images',
    handler: Sneakers::Handlers::Maxretry,
    workers: 1,
    threads: 1,
    timeout_job_after: 60,
    heartbeat_interval: 2,
    prefetch: 1,
    ack: true,
    :'x-dead-letter-exchange' => 'honeypot_images-retry',
    routing_key: ['honeypot_images']

  def work(*args)
    logger.info("HoneypotImageWorker rejecting args: #{args.inspect}")
    begin
      super(*args)
    rescue Exception => e
      Airbrake.notify(e, parameters: {args: args})
      reject!
    end
  end
end
