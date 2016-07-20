class ArchiveImageMediaFields < ActiveRecord::Migration
  def change
    rename_column :images, :image_content_type, :image_content_type_save
    rename_column :images, :image_file_name, :image_file_name_save
    rename_column :images, :image_file_size, :image_file_size_save
    rename_column :images, :image_fingerprint, :image_fingerprint_save
    rename_column :images, :image_meta, :image_meta_save
    rename_column :images, :image_updated_at, :image_updated_at_save
    rename_column :images, :json_response, :json_response_save
    rename_column :images, :status, :status_save
  end
end
