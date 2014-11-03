class AddTiledImages < ActiveRecord::Migration
  def change
    create_table :tiled_images do | t |
      t.string :url
      t.integer :width
      t.integer :height
    end
  end
end
