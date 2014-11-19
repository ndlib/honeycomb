class RecreateUserCollectionWithIndex < ActiveRecord::Migration
  def change
    create_table :collection_users do |t|
      t.integer :user_id, null: false
      t.integer :collection_id, null: false
      t.timestamps
    end
    add_index :collection_users, :user_id
    add_index :collection_users, :collection_id
  end
end
