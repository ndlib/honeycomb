class TiledImage < ActiveRecord::Base

  validates :width, :height, :url, presence: true
end
