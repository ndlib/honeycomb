class AddShowcaseToSections < ActiveRecord::Migration

  def change
    add_column :sections, :showcase_id, :integer
  end
end
