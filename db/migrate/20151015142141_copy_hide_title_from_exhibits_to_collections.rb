class CopyHideTitleFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      hide_title_on_home_page = exhibit.hide_title_on_home_page
      execute "UPDATE collections SET hide_title_on_home_page = #{hide_title_on_home_page}
               WHERE id = #{exhibit.collection_id}" unless hide_title_on_home_page.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    ExhibitMigration.reset_column_information
  end
end
