class HoneypotImageWorker < RetryWorker
  from_queue "honeypot_images",
             threads: 1,
             timeout_job_after: 60,
             prefetch: 1,
             retry_max_times: 5
end
