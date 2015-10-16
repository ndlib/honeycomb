class CopyCollectionIdsToHoneypotImages < ActiveRecord::Migration
  class Exhibit < ActiveRecord::Base
  end

  def up
    Exhibit.find_each do |exhibit|
      collection_id = exhibit.collection_id
      exhibit_id = exhibit.id
      execute "UPDATE honeypot_images SET collection_id = #{collection_id} WHERE exhibit_id = #{exhibit_id}"
    end

    Exhibit.reset_column_information
  end

  def down
    Exhibit.reset_column_information
  end
end
