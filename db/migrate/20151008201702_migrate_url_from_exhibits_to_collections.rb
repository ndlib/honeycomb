class MigrateUrlFromExhibitsToCollections < ActiveRecord::Migration
  class Exhibit < ActiveRecord::Base
  end

  def up
    add_column :collections, :url, :string
    Exhibit.find_each do |exhibit|
      url = exhibit.url
      execute "UPDATE collections SET url = '#{url}' WHERE id = #{exhibit.collection_id}" unless url.nil?
    end

    Exhibit.reset_column_information
  end

  def down
    remove_column :collections, :url

    Exhibit.reset_column_information
  end
end
