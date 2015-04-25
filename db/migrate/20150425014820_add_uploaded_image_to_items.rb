class AddUploadedImageToItems < ActiveRecord::Migration
  def change
    add_attachment :exhibits, :uploaded_image
  end
end
