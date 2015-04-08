class AddUniqueIdToShowcases < ActiveRecord::Migration
  def change
    add_column :showcases, :unique_id, :string
    add_index :showcases, :unique_id

    Showcase.all.each do | s |
      SaveShowcase.call(s, {})
    end
  end
end
