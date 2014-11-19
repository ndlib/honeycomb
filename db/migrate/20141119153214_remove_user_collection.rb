class RemoveUserCollection < ActiveRecord::Migration
  def change
    drop_table :collections_users
  end
end
