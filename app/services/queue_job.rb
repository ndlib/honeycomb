class QueueJob
  attr_reader :job_class

  def initialize(job_class)
    @job_class = job_class
  end

  def queue(*args)
    job_class.perform_later(*args)
  end
end
