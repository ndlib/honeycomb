class AddDeletedBooleanToCollections < ActiveRecord::Migration
  def up
    add_column :collections, :deleted, :boolean, :default => false
  end

  def down
    remove_column :collections, :deleted, :boolean
  end
end
