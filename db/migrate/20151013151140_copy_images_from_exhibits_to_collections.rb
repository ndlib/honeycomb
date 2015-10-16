class CopyImagesFromExhibitsToCollections < ActiveRecord::Migration
  class Exhibit < ActiveRecord::Base
  end

  def up
    Exhibit.find_each do |exhibit|
      copy_image(exhibit: exhibit)
      copy_uploaded_image(exhibit: exhibit)
    end
    Exhibit.reset_column_information
  end

  def copy_image(exhibit:) # rubocop:disable Metrics/AbcSize
    file_name = exhibit.image_file_name.nil? ? "NULL" : "'#{exhibit.image_file_name}'"
    content_type = exhibit.image_content_type.nil? ? "NULL" : "'#{exhibit.image_content_type}'"
    file_size = exhibit.image_file_size.nil? ? "NULL" : "'#{exhibit.image_file_size}'"
    updated_at = exhibit.image_updated_at.nil? ? "NULL" : "'#{exhibit.image_updated_at.utc.to_s(:db)}'"
    execute "UPDATE collections SET
              image_file_name = #{file_name},
              image_content_type = #{content_type},
              image_file_size = #{file_size},
              image_updated_at = #{updated_at}
            WHERE id = #{exhibit.collection_id}"
  end

  def copy_uploaded_image(exhibit:) # rubocop:disable Metrics/AbcSize
    uploaded_file_name = exhibit.uploaded_image_file_name.nil? ? "NULL" : "'#{exhibit.uploaded_image_file_name}'"
    uploaded_content_type = exhibit.uploaded_image_content_type.nil? ? "NULL" : "'#{exhibit.uploaded_image_content_type}'"
    uploaded_file_size = exhibit.uploaded_image_file_size.nil? ? "NULL" : "'#{exhibit.uploaded_image_file_size}'"
    uploaded_updated_at = exhibit.uploaded_image_updated_at.nil? ? "NULL" : "'#{exhibit.uploaded_image_updated_at.utc.to_s(:db)}'"
    execute "UPDATE collections SET
              uploaded_image_file_name = #{uploaded_file_name},
              uploaded_image_content_type = #{uploaded_content_type},
              uploaded_image_file_size = #{uploaded_file_size},
              uploaded_image_updated_at = #{uploaded_updated_at}
            WHERE id = #{exhibit.collection_id}"
  end

  def down
    Exhibit.reset_column_information
  end
end
