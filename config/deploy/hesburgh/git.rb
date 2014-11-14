Capistrano::Configuration.instance(:must_exist).load do

  unset(:repository)
  _cset(:repository) { "git@git.library.nd.edu:#{application}" }

  set :scm, :git
  set :deploy_via, :remote_cache

  default_run_options[:pty]     = true # needed for git password prompts

end
