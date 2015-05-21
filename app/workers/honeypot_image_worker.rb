require "sneakers/handlers/maxretry"

class HoneypotImageWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  from_queue "honeypot_images",
             handler: Sneakers::Handlers::Maxretry,
             workers: 1,
             threads: 1,
             timeout_job_after: 60,
             heartbeat_interval: 2,
             prefetch: 1,
             ack: true,
             arguments: {
               :"x-dead-letter-exchange" => "honeypot_images-retry",
             },
             routing_key: ["honeypot_images"]

  def work(*args)
    logger.info("HoneypotImageWorker rejecting args: #{args.inspect}")
    begin
      super(*args)
    rescue StandardError => e
      Airbrake.notify(e, parameters: { args: args })
      logger.error e.message
      logger.error args
      logger.error e.backtrace.join("\n")
      reject!
    end
  end
end
