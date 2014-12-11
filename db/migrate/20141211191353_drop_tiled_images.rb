class DropTiledImages < ActiveRecord::Migration
  def change
    drop_table :tiled_images
  end
end
