require 'hesburgh/symlink_shared'

Capistrano::Configuration.instance(:must_exist).load do
  set :rails_shared_directories, ['/vendor/bundle', '/config']
  set :rails_shared_files, ['/config/database.yml', '/config/secrets.yml']
  set :recipe_symlinks, fetch(:recipe_symlinks) + ['/log', '/vendor/bundle', '/config/database.yml', '/config/secrets.yml']

  _cset(:ruby) { fetch(:ruby_bin) ? File.join(ruby_bin, 'ruby') : 'ruby' }
  _cset(:bundler) { fetch(:ruby_bin) ? File.join(ruby_bin, 'bundle') : 'bundle' }
  _cset(:binstubs_path)  { File.join(shared_path, 'vendor/bundle/bin') }
  unset(:rake)
  _cset(:rake) { "cd #{release_path}; #{fetch(:bundler)} exec #{File.join(fetch(:binstubs_path), 'rake')} RAILS_ENV=#{fetch(:rails_env)}" }

  after 'deploy:update_code',
        'bundle:install',
        'assets:precompile'

  after 'deploy:setup',
        'und:rails_setup'

  namespace :deploy do
    task :start { }
    task :stop { }
    task :restart, roles: :app, except: { no_release: true } do
      run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
    end
  end

  namespace :assets do
    desc 'Precompile assets'
    task :precompile do
      run "#{fetch(:rake)} assets:precompile"
    end
  end

  namespace :bundle do
    desc 'Install gems in Gemfile'
    task :install, roles: :app do
      run "#{fetch(:bundler)} install --binstubs='#{fetch(:binstubs_path)}' --shebang '#{fetch(:ruby)}' --gemfile='#{File.join(release_path, 'Gemfile')}' --without development test --deployment"
    end
  end

  namespace :und do
    desc 'Setup initial shared files and folders'
    task :rails_setup do
      fetch(:rails_shared_directories).each do |directory|
        run "mkdir -p #{File.join(shared_path, directory)}"
      end
      fetch(:rails_shared_files).each do |file|
        run "touch #{File.join(shared_path, file)}"
      end
    end
  end
end
