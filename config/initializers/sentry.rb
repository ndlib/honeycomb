Raven.configure do |config|
  # Don't clog up Sentry with stuff from test and dev
  if !Rails.env.test? # && !Rails.env.development?
    config.dsn = 'https://c790d0fd10704faf8109aff3746727a1@o164480.ingest.sentry.io/5440329'
  end

  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
