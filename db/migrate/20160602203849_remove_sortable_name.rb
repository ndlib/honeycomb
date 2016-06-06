class RemoveSortableName < ActiveRecord::Migration
  def change
    remove_column :items, :sortable_name
  end
end
