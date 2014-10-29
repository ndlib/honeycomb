class CreateJoinTableUserCollection < ActiveRecord::Migration
  def change
    create_join_table :users, :collections do |t|
      t.integer :user_id
      t.integer :collection_id
    end
  end
end
