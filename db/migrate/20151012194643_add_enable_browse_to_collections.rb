class AddEnableBrowseToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :enable_browse, :bool
  end
end
