class MigrateItemNameAndDescriptionToSafeUnusedPlace < ActiveRecord::Migration
  def change
    rename_column :items, :name, :name_save
    rename_column :items, :description, :description_save
  end
end
