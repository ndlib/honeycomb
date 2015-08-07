module NotifyError
  MAX_MESSAGE_LENGTH = 1000
  class FallbackError < StandardError
  end
  def self.call(exception:, parameters: {}, component: nil, action: nil)
    notify_exception = fallback_exception(exception)
    if notify_exception != exception
      parameters[:original_exception] = exception
    end
    Airbrake.notify(notify_exception,
                    component: component,
                    action: action,
                    parameters: parameters,
                    cgi_data: environment_info)
  end

  private

  # Errbit indexes the message, but the value can't be indexed if it's larger than 1024 bytes.
  # This creates a new exception that limits the length of the message.
  def self.fallback_exception(exception)
    full_message = "#{exception.class}: #{exception.message}"
    if full_message.length > MAX_MESSAGE_LENGTH
      fallback_message = full_message[0, MAX_MESSAGE_LENGTH - "#{FallbackError}: ".length]
      new_exception = FallbackError.exception(fallback_message)
      new_exception.set_backtrace(exception.backtrace)
      new_exception
    else
      exception
    end
  end

  def self.environment_info
    ENV.reject do |k|
      Airbrake.configuration.rake_environment_filters.include? k
    end
  end
end
