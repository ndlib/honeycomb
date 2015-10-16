class CopyEnableBrowseFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      enable_browse = exhibit.enable_browse
      execute "UPDATE collections SET enable_browse = #{enable_browse} WHERE id = #{exhibit.collection_id}" unless enable_browse.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    ExhibitMigration.reset_column_information
  end
end
