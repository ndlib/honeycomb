class MigrateDescriptionsToCollections < ActiveRecord::Migration
  class Exhibit < ActiveRecord::Base
  end

  def up
    add_column :collections, :site_intro, :text
    add_column :collections, :short_intro, :text
    Exhibit.find_each do |exhibit|
      site_intro = exhibit.description
      short_intro = exhibit.short_description
      execute "UPDATE collections SET site_intro = '#{site_intro}' WHERE id = #{exhibit.collection_id}" unless site_intro.nil?
      execute "UPDATE collections SET short_intro = '#{short_intro}' WHERE id = #{exhibit.collection_id}" unless short_intro.nil?
    end

    Exhibit.reset_column_information
    Collection.reset_column_information
  end

  def down
    remove_column :collections, :site_intro
    remove_column :collections, :short_intro

    Exhibit.reset_column_information
    Collection.reset_column_information
  end
end
