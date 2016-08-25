class ChangePageImageToMedia < ActiveRecord::Migration
  def up
    remove_foreign_key :pages, :images
    rename_column :pages, :image_id, :media_id
    add_foreign_key :pages, :media, column: :media_id
  end

  def down
    remove_foreign_key :pages, column: :media_id
    rename_column :pages, :media_id, :image_id
    add_foreign_key :pages, :images
  end
end
