class AddUploadedImageToItems < ActiveRecord::Migration
  def change
    add_attachment :items, :uploaded_image
  end
end
