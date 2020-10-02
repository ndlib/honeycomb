# Loads non-sensitive application configuration from config/settings.yml and makes it available from Rails.configuration.settings
Rails.application.configure do
  # config_data = YAML.load_file(Rails.root.join("config", "settings.yml"))
  path = Rails.root.join("config", "settings.yml")
  template = ERB.new(File.read(path))
  processed = template.result(binding)
  config_data = YAML.load(processed)

  config.settings = ActiveSupport::OrderedOptions.new
  config_data[Rails.env].each do |key, value|
    config.settings[key] = value
  end
end
