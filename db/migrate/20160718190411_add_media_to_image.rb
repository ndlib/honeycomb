class AddMediaToImage < ActiveRecord::Migration
  def change
    add_column :images, :data, :jsonb, null: false, default: '{}'
    add_column :images, :type, :text
  end
end
