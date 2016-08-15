class ChangeImageToMedia < ActiveRecord::Migration
  def up
    remove_foreign_key :items, :images
    remove_foreign_key :collections, :images
    remove_foreign_key :showcases, :images

    rename_column :items, :image_id, :media_id
    rename_column :collections, :image_id, :media_id
    rename_column :showcases, :image_id, :media_id
    rename_table :images, :media

    add_foreign_key :items, :media, column: :media_id
    add_foreign_key :collections, :media, column: :media_id
    add_foreign_key :showcases, :media, column: :media_id
  end

  def down
    remove_foreign_key :items, column: :media_id
    remove_foreign_key :collections, column: :media_id
    remove_foreign_key :showcases, column: :media_id

    rename_table :media, :images
    rename_column :items, :media_id, :image_id
    rename_column :collections, :media_id, :image_id
    rename_column :showcases, :media_id, :image_id

    add_foreign_key :items, :images
    add_foreign_key :collections, :images
    add_foreign_key :showcases, :images
  end
end
