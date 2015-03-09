class AddUniqueIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :unique_id, :string
    add_index :collections, :unique_id
  end
end
