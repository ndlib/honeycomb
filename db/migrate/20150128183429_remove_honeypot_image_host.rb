class RemoveHoneypotImageHost < ActiveRecord::Migration
  def change
    remove_column :honeypot_images, :host
  end
end
