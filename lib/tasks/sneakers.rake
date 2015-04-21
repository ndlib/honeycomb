require 'sneakers'
require 'sneakers/runner'

task :environment

namespace :sneakers do
  def pid_file
    Rails.root.join('tmp/pids/sneakers.pid')
  end

  desc "Start work (set JOB_QUEUES=default,active_job_two,active_job_one)"
  task :run  => :environment do
    if File.exists?(pid_file)
      raise "pid file exists: #{pid_file}"
    end
    File.open(pid_file, 'w'){|f| f.puts Process.pid}
    begin
      workers = (ENV['JOB_QUEUES'] || '').split(',').map do |q|
        queue_name = q.strip
        worker_klass = "ActiveJobQueue_#{queue_name}"
        Sneakers.const_set(worker_klass, Class.new(ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper) do
          from_queue queue_name
        end)
      end
      workers << HoneypotImageWorker
      r = Sneakers::Runner.new(workers)

      r.run
    ensure
      File.delete pid_file
    end
  end

  task :stop do
    if File.exists?(pid_file)
      pid = File.read(pid_file).strip.to_i
      puts "Stopping sneakers..."
      Process.kill("INT", pid)
      stopped = false
      10.times do
        begin
          Process.kill(0, pid)
        rescue Errno::ESRCH
          stopped = true
          break
        end
        sleep(1)
      end
      if stopped
        puts "Stopped sneakers"
      else
        puts "INT sent to pid #{pid}, sneakers not stopped"
      end
    else
      puts "Sneakers not running"
    end
  end
end
