class AddTiledImages < ActiveRecord::Migration
  def change
    create_table :tiled_images do |t|
      t.integer :item_id
      t.string :uri
      t.integer :width
      t.integer :height
    end
  end
end
