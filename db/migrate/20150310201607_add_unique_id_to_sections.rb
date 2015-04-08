class AddUniqueIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :unique_id, :string
    add_index :sections, :unique_id

    Section.all.each do | s |
      SaveSection.call(s, {})
    end

  end
end
