require 'socket'
require 'ipaddr'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.force_ssl = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  default_url_options = {
    host: "localhost",
    port: 3017,
    protocol: "https",
  }
  config.action_mailer.default_url_options = default_url_options
  Rails.application.routes.default_url_options = default_url_options

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.react.variant = :development

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

    # When inside a docker container
    if File.file?('/.dockerenv')
      # Whitelist docker ip for web console
      # Cannot render console from 172.27.0.1! Allowed networks: 127.0.0.1
      Socket.ip_address_list.each do |addrinfo|
        next unless addrinfo.ipv4?
        next if addrinfo.ip_address == "127.0.0.1" # Already whitelisted
  
        ip = IPAddr.new(addrinfo.ip_address).mask(24)
  
        Logger.new(STDOUT).info "Adding #{ip.inspect} to config.web_console.whitelisted_ips"
  
        config.web_console.whitelisted_ips << ip
      end
    end
  
  # if ENV["DALLI"]
  #   config.action_controller.perform_caching = true
  #   client = Dalli::Client.new
  #   config.action_dispatch.rack_cache = {
  #     metastore: client,
  #     entitystore: client
  #   }
  #
  #   config.middleware.use Rack::Cache,
  #                         verbose: true,
  #                         metastore: client,
  #                         entitystore: client
  #
  #   config.cache_store = :dalli_store
  # end
end
