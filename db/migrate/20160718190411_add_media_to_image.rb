class AddMediaToImage < ActiveRecord::Migration
  def up
    add_column :images, :data, :jsonb, null: false, default: '{}'
    add_column :images, :type, :string
    # Allowing nulls to make sure we can add new images using the new data field
    # prior to archiving the old columns
    change_column :images, :image_file_name, :text, null: true
    change_column :images, :image_fingerprint, :text, null: true
  end

  def down
    remove_column :images, :data, :jsonb, null: false, default: '{}'
    remove_column :images, :type, :string
    # If this fails, it means there are records that were added with image data
    # stored in the jsonb field. The only solutions are to:
    #  a) delete those records
    #  b) copy the data out of the jsonb back into these attributes
    # Neither of these make sense to do automagically when rolling back this migration
    change_column :images, :image_file_name, :text, null: false
    change_column :images, :image_fingerprint, :text, null: false
  end
end
