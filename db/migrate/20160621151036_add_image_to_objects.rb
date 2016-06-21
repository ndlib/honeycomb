class AddImageToObjects < ActiveRecord::Migration
  def change
    add_column :items, :image_id, :integer
    add_foreign_key :items, :images

    add_column :collections, :image_id, :integer
    add_foreign_key :collections, :images

    add_column :showcases, :image_id, :integer
    add_foreign_key :showcases, :images
  end
end
