class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string          :first_name
      t.string          :last_name
      t.string          :display_name
      t.string          :email, :null => false, :default => ""
      t.integer         :sign_in_count, :default => 0
      t.datetime        :current_sign_in_at
      t.datetime        :last_sign_in_at
      t.string          :current_sign_in_ip
      t.string          :last_sign_in_ip
      t.string          :username, :unique => true
      t.timestamps
    end

    add_index :users, :email
    add_index :users, :username, :unique => true
  end
end
