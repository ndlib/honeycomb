class ArchiveOldImageFields < ActiveRecord::Migration
  def change
    rename_column :collections, :image_file_name, :image_file_name_save
    rename_column :collections, :image_content_type, :image_content_type_save
    rename_column :collections, :image_file_size, :image_file_size_save
    rename_column :collections, :image_updated_at, :image_updated_at_save

    rename_column :collections, :uploaded_image_file_name, :uploaded_image_file_name_save
    rename_column :collections, :uploaded_image_content_type, :uploaded_image_content_type_save
    rename_column :collections, :uploaded_image_file_size, :uploaded_image_file_size_save
    rename_column :collections, :uploaded_image_updated_at, :uploaded_image_updated_at_save

    rename_column :showcases, :image_file_name, :image_file_name_save
    rename_column :showcases, :image_content_type, :image_content_type_save
    rename_column :showcases, :image_file_size, :image_file_size_save
    rename_column :showcases, :image_updated_at, :image_updated_at_save

    rename_column :showcases, :uploaded_image_file_name, :uploaded_image_file_name_save
    rename_column :showcases, :uploaded_image_content_type, :uploaded_image_content_type_save
    rename_column :showcases, :uploaded_image_file_size, :uploaded_image_file_size_save
    rename_column :showcases, :uploaded_image_updated_at, :uploaded_image_updated_at_save

    rename_column :items, :image_file_name, :image_file_name_save
    rename_column :items, :image_content_type, :image_content_type_save
    rename_column :items, :image_file_size, :image_file_size_save
    rename_column :items, :image_updated_at, :image_updated_at_save
    rename_column :items, :image_status, :image_status_save

    rename_column :items, :uploaded_image_file_name, :uploaded_image_file_name_save
    rename_column :items, :uploaded_image_content_type, :uploaded_image_content_type_save
    rename_column :items, :uploaded_image_file_size, :uploaded_image_file_size_save
    rename_column :items, :uploaded_image_updated_at, :uploaded_image_updated_at_save
  end
end
