class AddCustomSlugToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :url_slug, :string
    add_index :collections, :url_slug, unique: true
  end
end
