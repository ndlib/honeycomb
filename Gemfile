source "https://rubygems.org"

# Don't load all mime types
gem "mime-types", "~> 2.6.1", require: "mime/types/columnar"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 4.2.0"

gem "responders", "~> 2.0"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem "therubyracer",  platforms: :ruby

gem "pg"

gem "aws-sdk", "~> 2"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

gem "paperclip"
gem "paperclip-meta"

gem "hesburgh_infrastructure", git: "https://github.com/ndlib/hesburgh_infrastructure.git"
gem "hesburgh_api", git: "https://github.com/ndlib/hesburgh_api.git"

gem "simple_form", "~> 3.1.0"

gem "draper"

gem "nokogiri"

# used to normaize the characters in a title sort
gem "sort_alphabetical"

# To support m/d/y formats
gem "american_date"

gem "rb-readline"

gem "devise"
gem "devise_cas_authenticatable"

gem "addressable"

# Server monitoring
gem "newrelic_rpm"

gem "paper_trail", "~> 4.0.0.beta2"

gem "faraday"
gem "faraday_middleware"

gem "rsolr"

gem "sanitize"

# Background processing
gem "sneakers"

# For Errbit
gem "airbrake"

# For cron tasks
gem "whenever", require: false

# Javascript assets
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
gem "react-rails"
gem "react-rails-img", git: "https://github.com/jonhartzler/react-rails-img.git"
gem "browserify-rails", "~>0.7.2"
gem "underscore-rails"
gem "showdown-rails"
gem "therubyracer"
# Use jquery as the JavaScript library
gem "jquery-rails", "3.1.2"
gem "jquery-ui-rails", "5.0.2"
gem "jquery-datatables-rails", "~> 3.3.0"
gem "coffee-rails", "~> 4.0.0"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem "turbolinks"

# CSS
# Use SCSS for stylesheets
gem "sass-rails", "~> 4.0.3"
gem "bootstrap-sass", "~> 3.3.1"
gem "bootstrap-material-design"
gem "autoprefixer-rails"

gem "google_drive", git: "https://github.com/ndlib/google-drive-ruby.git", branch: "DEC-1008-Speedup-update-cells"

group :development, :test do
  gem "rubocop", "~> 0.36.0", require: false

  # gem "i18n-debug"
  gem "pry"
  gem "pry-nav"
  gem "rspec-rails"
  gem "rspec-collection_matchers"
  gem "capybara"
  gem "faker"
  gem "spring"
  gem "spring-commands-rspec"
  gem "rake", "< 11"

  gem "quiet_assets"

  gem "guard"
  gem "guard-bundler"
  gem "guard-coffeescript"
  gem "guard-rails"
  gem "guard-rspec"
  gem "guard-spring"
  gem "guard-npm"
  #  gem "growl"
  #  gem "ruby_gntp"
  #  gem "growl-rspec"

  gem "coveralls", require: false

  gem "web-console", "~> 2.0"

  gem "factory_girl_rails"

  gem "rails-erd"
end

gem "codeclimate-test-reporter", group: :test, require: nil

# Dalli Caching
gem "rack-cache"
gem "dalli"
gem 'cacheable_flash'

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use unicorn as the app server
# gem "unicorn"

# Use Capistrano for deployment
gem "capistrano", "~> 3.1"
gem "capistrano-rails", "~> 1.1"
gem "capistrano-npm"

# Use debugger
# gem "debugger", group: [:development, :test]
