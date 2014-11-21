Capistrano::Configuration.instance(:must_exist).load do

  _cset :application_symlinks, []
  set :recipe_symlinks, []

  _cset(:symlink_targets) { recipe_symlinks + application_symlinks }

  after 'deploy:update_code', 'deploy:create_symlink_shared'

  namespace :deploy do

    desc "Symlink shared configs and folders on each release."
    task :create_symlink_shared do
      symlink_targets.each do | target |
        if target.is_a?(Hash)
          source      = target.keys.first
          destination = target.values.first
        else
          source = target
          destination = target
        end

        destination_path = File.join( release_path, destination)
        destination_directory = File.dirname(destination_path)

        run "rm -rf #{destination_path}"
        run "mkdir -p #{destination_directory}"
        run "ln -nvfs #{File.join( shared_path, source)} #{destination_path}"
      end
    end
  end
end
