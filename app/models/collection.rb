class Collection < ActiveRecord::Base
  has_many :items
  has_many :collections_users
  has_many :users, :through => :collections_users

  validates :title, presence: true

end
