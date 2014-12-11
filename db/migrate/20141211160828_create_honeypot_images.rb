class CreateHoneypotImages < ActiveRecord::Migration
  def change
    create_table :honeypot_images do |t|
      t.integer :item_id
      t.string :title
      t.string :host
      t.text :json_response
      t.timestamps
    end

    add_index :honeypot_images, :item_id
  end
end
