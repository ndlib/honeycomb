class AddUniqueIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :unique_id, :string
    add_index :items, :unique_id

    Item.all.each do | s |
      SaveItem.call(s, {})
    end
  end
end
