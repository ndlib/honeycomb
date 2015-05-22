class ChangeTitleToName < ActiveRecord::Migration
  def change
    rename_column :items, :title, :name
    rename_column :items, :sortable_title, :sortable_name
    rename_column :collections, :title, :name_line_1
    rename_column :collections, :subtitle, :name_line_2
    rename_column :showcases, :title, :name_line_1
    rename_column :showcases, :subtitle, :name_line_2
  end
end
