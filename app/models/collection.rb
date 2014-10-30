class Collection < ActiveRecord::Base
  has_many :items
  has_many :collection_users
  has_many :users, :through => :collection_users

  validates :title, presence: true

end
