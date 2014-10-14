class Collection < ActiveRecord::Base
  has_many :items

  validates :title, presence: true


  def new_item
    items.build
  end
end
