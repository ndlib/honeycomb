# Add the deploy directory to the load path
$:.unshift File.join(File.dirname(__FILE__),'deploy')
require 'hesburgh/common'
require 'hesburgh/git'
require 'hesburgh/vm'
require 'hesburgh/rails'
require 'hesburgh/rails_db'
require 'hesburgh/jenkins'
require 'hesburgh/prompt_branch'
# require 'hesburgh/whenever'

set :application, 'honeycomb'
set :repository, "https://github.com/ndlib/honeycomb.git"

set :application_symlinks, ['config/secrets.yml', 'config/hesburgh_api.yml']

desc "Setup for the Pre-Production environment"
task :pre_production do
  # Customize pre_production configuration
  set :rails_env, 'pre_production'
  role :app, "honeycombpprd-vm.library.nd.edu"
end

desc "Setup for the production environment"
task :production do
  # Customize production configuration
  set :rails_env, 'production'
  role :app, "honeycombprod-vm.library.nd.edu"
end
