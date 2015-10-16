class AddCollectionsToHoneypotImages < ActiveRecord::Migration
  def change
    add_column :honeypot_images, :collection_id, :integer
  end
end
