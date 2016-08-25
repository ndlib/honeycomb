class ChangePageImageToMedia < ActiveRecord::Migration
  def change
    remove_foreign_key :pages, :images
    rename_column :pages, :image_id, :media_id
    add_foreign_key :pages, :media, column: :media_id
  end
end
