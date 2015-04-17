Sneakers.configure({
  amqp: Rails.application.secrets.sneakers["amqp"],
  vhost: Rails.application.secrets.sneakers["vhost"],
  workers: 1,
  heartbeat: 5,
})
