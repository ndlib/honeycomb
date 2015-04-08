# Loads non-sensitive application configuration from config/settings.yml and makes it available from Rails.configuration.settings
Rails.application.configure do
  config_data = YAML.load_file(Rails.root.join('config','settings.yml'))

  config.settings = ActiveSupport::OrderedOptions.new
  config_data[Rails.env].each do |key,value|
    config.settings[key] = value
  end
end
