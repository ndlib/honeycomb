class AddMediaToImage < ActiveRecord::Migration
  def change
    add_column :images, :data, :jsonb, null: false, default: '{}'
    add_column :images, :media_type, :text
    # Allowing nulls to make sure we can add new images using the new data field
    # prior to archiving the old columns
    change_column :images, :image_file_name, :text, null: true
    change_column :images, :image_fingerprint, :text, null: true
  end
end
