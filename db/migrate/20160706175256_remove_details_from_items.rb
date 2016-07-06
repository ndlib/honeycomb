class RemoveDetailsFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :name_save, :text
    remove_column :items, :description_save, :text
  end
end
