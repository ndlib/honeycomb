class QueueJob
  attr_reader :job_class

  def initialize(job_class)
    @job_class = job_class
  end

  def queue(*args)
    if process_in_background?
      job_class.perform_later(*args)
    else
      job_class.perform_now(*args)
    end
  end

  def self.call(job_class, *args)
    new(job_class).queue(*args)
  end

  private

  def process_in_background?
    Rails.configuration.settings.background_processing
  end
end
