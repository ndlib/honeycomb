require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ItemAdmin
  class Application < Rails::Application

    additional_autoload_directories = [
      Rails.root.join('lib'),
      Rails.root.join('app', 'queries'),
      Rails.root.join('app', 'decorators'),
      Rails.root.join('app', 'policy'),
      Rails.root.join('app', 'services'),
      ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Custom configs
    config.honeycomb_ldap_host = 'directory.nd.edu'
    config.honeycomb_ldap_port = 636
    config.honeycomb_ldap_base = 'o=University of Notre Dame,st=Indiana,c=US'
    config.honeycomb_ldap_service_dn = 'ndGuid=nd.edu.nddk4kq4,ou=objects,o=University of Notre Dame,st=Indiana,c=US'
    config.honeycomb_ldap_service_password = 'zfkpqns8'
    config.honeycomb_ldap_attrs = [ 'uid', 'givenname', 'sn', 'ndvanityname', 'nddepartment' ]


  end
end
