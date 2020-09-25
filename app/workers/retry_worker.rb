require "sneakers/handlers/maxretry"

class RetryWorker < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  WORKERS = 1

  def self.from_queue(queue_name, options = {})
    base_options = {
      handler: Sneakers::Handlers::Maxretry,
      arguments: {
        :"x-dead-letter-exchange" => "#{queue_name}-retry",
      },
      routing_key: [queue_name],
    }
    options = options.merge(base_options)

    super(queue_name, options)
  end

  def self.number_of_workers
    self::WORKERS
  end

  alias_method :original_work, :work

  def work(*args)
    original_work(*args)
  rescue StandardError => e
    Raven.capture_exception(exception)
    logger.error e.message
    logger.error args
    logger.error e.backtrace.join("\n")
    reject!
  end
end
