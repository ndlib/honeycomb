require 'hesburgh_infrastructure'
# application_name must match an application in the hesburgh_infrastructure gem
# New applications must be added to config/applications.yml in hesburgh_infrastructure
hesburgh_guard = HesburghInfrastructure::Guard.new(:item_admin, self)

# Automatically compile CoffeeScript files
# https://github.com/guard/guard-coffeescript
hesburgh_guard.coffeescript

# Automatically install/update your gem bundle when needed
# https://github.com/guard/guard-bundler
hesburgh_guard.bundler gemspec: false do
  # Watch any custom paths
end

# Automatically start/restart your Rails development server
# https://github.com/ranmocy/guard-rails
hesburgh_guard.rails do
  # Watch any custom paths
end

# Automatically run your specs
# https://github.com/guard/guard-rspec
hesburgh_guard.rspec do
  # Watch any custom paths
end

guard 'spring', :rspec_cli => '--color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$})                   { |m| 'spec' }
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
    %W(spec/routing/#{m[1]}_routing_spec.rb spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb spec/requests/#{m[1]}_spec.rb)
  end
end
