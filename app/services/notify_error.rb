module NotifyError
  def self.call(exception:, parameters: {}, component: nil, action: nil)
    notify_exception = clean_exception(exception)
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
  def self.clean_exception(exception)
    maximum_message_length = 1000 - "#{exception.class}: ".length
    if exception.message.length > maximum_message_length
      new_exception = exception.exception(exception.message[0, maximum_message_length])
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
