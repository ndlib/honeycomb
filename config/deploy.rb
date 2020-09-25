# config valid only for current version of Capistrano
lock "3.5"

require "new_relic/recipes"

set :application, "honeycomb"
set :repo_url, "https://github.com/ndlib/honeycomb.git"

set :log_level, :info

# Default branch is :master
if ENV["SCM_BRANCH"] && !(ENV["SCM_BRANCH"] == "")
  set :branch, ENV["SCM_BRANCH"]
else
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
end

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/app/honeycomb"

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
set :linked_files, %w{config/database.yml config/secrets.yml config/hesburgh_api.yml}

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system node_modules}

set :default_env, path: "/opt/bin:/opt/ruby/current/bin:$PATH"

namespace :deploy do
  desc "Restart application"

  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

namespace :sneakers do
  task :restart do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rack_env) do
          execute :rake, "sneakers:restart"
        end
      end
    end
  end
end

after "deploy:finished", "sneakers:restart"

before "npm:install", "npm:prune"

after "deploy:finished", "deploy:updated", "newrelic:notice_deployment"
