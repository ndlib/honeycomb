require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ItemAdmin
  class Application < Rails::Application
    additional_autoload_directories = [
      Rails.root.join("lib"),
      Rails.root.join("app", "queries"),
      Rails.root.join("app", "decorators"),
      Rails.root.join("app", "policy"),
      Rails.root.join("app", "services"),
      Rails.root.join("app", "forms"),
      Rails.root.join("app", "values"),
      Rails.root.join("app", "validators"),
      Rails.root.join("app", "presenters")
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = "Central Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    # config.i18n.default_locale = :de

    config.react.variant = :production
    config.react.addons = true
    config.browserify_rails.commandline_options = "--transform  [ reactify --es6 ] --extension=\".jsx\""

    config.assets.precompile = [proc { |path| !File.extname(path).in?([".js", ".css", ".map", ".gzip", ""]) }, /(?:\/|\\|\A)application\.(css|js)$/]

    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sneakers
  end
end
