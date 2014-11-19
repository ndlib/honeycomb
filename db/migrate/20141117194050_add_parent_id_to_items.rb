class AddParentIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :parent_id, :integer
    add_index :items, :parent_id
  end
end
