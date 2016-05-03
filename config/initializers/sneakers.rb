require "sneakers/handlers/maxretry"

Sneakers.configure(
  amqp: Rails.application.secrets.sneakers["amqp"],
  vhost: Rails.application.secrets.sneakers["vhost"],
  workers: 2,
  heartbeat: 2,
  prefetch: 15,
  threads: 15,
  exchange: "honeycomb",
  exchange_type: "topic",
  durable: true,
  log: "log/sneakers.log"
)
