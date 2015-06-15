# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: "Emanuel", city: cities.first)

User.new(username: "jhartzle", admin: true).save!(validate: false)
User.new(username: "dwolfe2", admin: true).save!(validate: false)
User.new(username: "rfox2", admin: true).save!(validate: false)
User.new(username: "rmallot", admin: true).save!(validate: false)
User.new(username: "jkennel", admin: true).save!(validate: false)
User.new(username: "awetheri", admin: true).save!(validate: false)
User.new(username: "jgondron", admin: true).save!(validate: false)
