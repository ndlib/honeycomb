require "sneakers/handlers/maxretry"

Sneakers.configure(
  amqp: Rails.application.secrets.sneakers["amqp"],
  vhost: Rails.application.secrets.sneakers["vhost"],
  workers: 1,
  heartbeat: 5,
  exchange: "honeycomb",
  exchange_type: "topic",
  durable: true,
  log: "log/sneakers.log",
)
