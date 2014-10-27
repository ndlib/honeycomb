class AddSortableTitleToItem < ActiveRecord::Migration
  def change
    add_column :items, :sortable_title, :text
  end
end
