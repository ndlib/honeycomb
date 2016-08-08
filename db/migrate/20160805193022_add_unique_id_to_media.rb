class AddUniqueIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :uuid, :uuid
    add_index :media, :uuid
  end
end
