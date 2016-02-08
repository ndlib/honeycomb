class RenameSiteObjectsToSitePath < ActiveRecord::Migration
  def change
    rename_column :collections, :site_objects, :site_path
  end
end
