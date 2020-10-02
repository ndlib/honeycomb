require "sneakers/handlers/maxretry"

Sneakers.configure(
  amqp: Rails.application.secrets.sneakers["amqp"],
  vhost: Rails.application.secrets.sneakers["vhost"],
  workers: 1,
  heartbeat: 5,
  exchange: "honeycomb",
  exchange_type: "topic",
  durable: true,
  log: ENV["RAILS_LOG_TO_STDOUT"].present? ? STDOUT : "log/sneakers.log",
)
Sneakers.logger.level = Logger::WARN
