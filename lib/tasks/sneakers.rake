require 'sneakers'
require 'sneakers/runner'

task :environment

namespace :sneakers do
  desc "Start work (set JOB_QUEUES=default,active_job_two,active_job_one)"
  task :run  => :environment do
    workers = (ENV['JOB_QUEUES'] || 'default').split(',').map do |q|
      queue_name = q.strip
      worker_klass = "ActiveJobQueue_#{queue_name}"
      Sneakers.const_set(worker_klass, Class.new(ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper) do
        from_queue queue_name
      end)
    end
    workers << HoneypotImageWorker
    r = Sneakers::Runner.new(workers)

    r.run
  end
end
