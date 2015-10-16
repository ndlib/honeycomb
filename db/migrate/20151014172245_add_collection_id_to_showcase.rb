class AddCollectionIdToShowcase < ActiveRecord::Migration
  def change
    add_column :showcases, :collection_id, :integer
    add_index :showcases, :collection_id
  end
end
