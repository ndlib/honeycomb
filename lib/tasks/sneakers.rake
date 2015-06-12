require 'sneakers'
require 'sneakers/runner'

task :environment

namespace :sneakers do
  def pid_file
    Rails.root.join('tmp/pids/sneakers.pid')
  end

  task :start do
    puts "Starting sneakers"
    Process.fork do
      Rake::Task["sneakers:run"].invoke
    end
    puts "Started sneakers"
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
      default_worker_classes = [
        HoneypotImageWorker,
        UploadedImageWorker,
      ]
      default_worker_classes.each do |worker_class|
        worker_class.number_of_workers.times do
          workers << worker_class
        end
      end

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
      60.times do
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

  task :restart do
    Rake::Task["sneakers:stop"].invoke
    Rake::Task["sneakers:start"].invoke
  end
end
