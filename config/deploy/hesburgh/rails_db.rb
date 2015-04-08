Capistrano::Configuration.instance(:must_exist).load do

  #############################################################
  #  Database
  #############################################################

  after 'deploy:update_code', 'db:migrate'

  namespace :db do
    desc "Run the seed rake task."
    task :seed, :roles => :app do
      run "#{rake} db:seed"
    end

    desc "Run the reset rake task."
    task :reset, :roles => :app do
      run "#{rake} db:reset"
    end

    desc "Run the migrate rake task."
    task :migrate, :roles => :app do
      run "#{rake} db:migrate"
    end
  end
end
