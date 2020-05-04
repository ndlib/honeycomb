class HoneycombIndexWorker < RetryWorker
  from_queue "honeycomb_index",
             threads: 1,
             timeout_job_after: 3600,
             prefetch: 1,
             retry_max_times: 1
end
