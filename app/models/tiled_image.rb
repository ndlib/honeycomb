class TiledImage < ActiveRecord::Base
  belongs_to :item

  validates :width, :height, :uri, presence: true
end
