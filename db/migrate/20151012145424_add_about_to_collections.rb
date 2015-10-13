class AddAboutToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :about, :text
  end
end
