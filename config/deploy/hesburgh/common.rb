Capistrano::Configuration.instance(:must_exist).load do

  after "deploy:restart", "deploy:cleanup"

end
