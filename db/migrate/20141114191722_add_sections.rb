class AddSections < ActiveRecord::Migration
  def change
    create_table :sections do | t |
      t.string :title
      t.text :description
      t.string :image
      t.integer :item_id
    end
  end
end
