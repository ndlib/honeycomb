class AddHideTitleToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :hide_title_on_home_page, :bool
  end
end
