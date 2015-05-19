class ChangeItemsTitleToName < ActiveRecord::Migration
  def change
    rename_column :items, :title, :name
    rename_column :items, :sortable_title, :sortable_name
  end
end
