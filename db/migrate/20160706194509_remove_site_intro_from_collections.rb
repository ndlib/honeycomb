class RemoveSiteIntroFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :site_intro, :text
  end
end
