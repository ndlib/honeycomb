class AddEnableSearchToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :enable_search, :bool
  end
end
