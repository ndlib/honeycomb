class Media < ActiveRecord::Base
  belongs_to :collection
  has_many :items
  validates :collection, presence: true
end
