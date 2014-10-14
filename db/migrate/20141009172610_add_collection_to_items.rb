class AddCollectionToItems < ActiveRecord::Migration
  def change
    add_column :items, :collection_id, :integer
    add_index :items, :collection_id
  end
end
