Capistrano::Configuration.instance(:must_exist).load do
  set(:deploy_to) { "/home/app/#{application}" }

  set :user,      'app'
  set :use_sudo, false

  set :ruby_bin, '/opt/ruby/current/bin'
end
