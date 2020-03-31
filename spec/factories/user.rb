FactoryGirl.define do
  factory :user, class: 'User' do |u|
    u.id { 2 }
    u.first_name { "One" }
    u.last_name { "User" }
    u.display_name { "User One" }
    u.email { "noone@nowhere.com" }
    u.sign_in_count { 1 }
    u.username { "user1" }
    u.admin { false }
  end

  factory :admin_user, class: 'User' do |u|
    u.id { 1 }
    u.first_name { "One" }
    u.last_name { "User" }
    u.display_name { "User One" }
    u.email { "noone@nowhere.com" }
    u.sign_in_count { 1 }
    u.username { "user1" }
    u.admin { true }
  end
end
