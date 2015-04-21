require 'sneakers/handlers/maxretry'

Sneakers.configure({
  handler: Sneakers::Handlers::Maxretry,
  amqp: Rails.application.secrets.sneakers["amqp"],
  vhost: Rails.application.secrets.sneakers["vhost"],
  workers: 1,
  heartbeat: 5,
  exchange: 'honeycomb',
  exchange_type: 'topic',
  routing_key: ['honeypot_images'],
  durable: true,
  log: 'log/sneakers.log',
})
