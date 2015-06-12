require "sneakers/handlers/maxretry"

class RetryWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  WORKERS = 1

  def self.set_retry_queue(queue_name, options = {})
    options = options.merge({
      handler: Sneakers::Handlers::Maxretry,
      arguments: {
        :"x-dead-letter-exchange" => "#{queue_name}-retry",
      },
      routing_key: [queue_name],
    })
    from_queue queue_name, options
  end

  def self.number_of_workers
    WORKERS
  end

  def work(*args)
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
