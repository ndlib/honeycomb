class CopyEnableSearchFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      enable_search = exhibit.enable_search
      execute "UPDATE collections SET enable_search = #{enable_search} WHERE id = #{exhibit.collection_id}" unless enable_search.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    ExhibitMigration.reset_column_information
  end
end
