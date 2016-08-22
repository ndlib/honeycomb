# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: "Emanuel", city: cities.first)

[
  "jhartzle",
  "dwolfe2",
  "rfox2",
  "jkennel",
  "awetheri",
  "jgondron",
  "lrobins5"
].each do |username|
  u = User.where(username: username).first || User.new(username: username)
  u.admin = true
  u.save!
end

brood = Brood::Repo.new(github: "ndlib/honeycomb-brood")
brood.grow!
