unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/ext/multistage requires Capistrano 2"
end

Capistrano::Configuration.instance.load do
  def prompt_with_default(var, default, message = nil)
    set(var) do
      Capistrano::CLI.ui.ask "#{"\n" + message if message}#{var} [#{default}] : "
    end
    set var, default if eval("#{var.to_s}.empty?")
  end

  def current_git_branch
    result = `git branch | grep '^\*'`.gsub(/^\*\ */, '').strip.chomp rescue 'master'
    result.to_s.empty? ? 'master' : result
  end

  before 'deploy:update_code', 'deploy:set_scm_branch'

  namespace :deploy do
    desc "Set SCM branch"
    task :set_scm_branch do
      set :branch, 'master'
      if ENV["SCM_BRANCH"] && !(ENV["SCM_BRANCH"] == "")
        set :branch, ENV["SCM_BRANCH"]
      elsif rails_env == 'production'
        prompt_with_default(:branch, 'master')
      else
        prompt_with_default(:branch, current_git_branch)
      end
    end
  end
end
