class TiledImage < ActiveRecord::Base
  belongs_to :item

  validates :width, :height, :host, :path, presence: true
end
