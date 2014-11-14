Capistrano::Configuration.instance(:must_exist).load do

  ssh_options[:paranoid] = false
  ssh_options[:keys] = %w(/shared/jenkins/.ssh/id_dsa /opt/jenkins/.ssh/id_rsa)

end
