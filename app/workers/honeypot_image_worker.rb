class HoneypotImageWorker < RetryWorker
  set_retry_queue "honeypot_images",
                  threads: 1,
                  timeout_job_after: 60,
                  prefetch: 1
end
