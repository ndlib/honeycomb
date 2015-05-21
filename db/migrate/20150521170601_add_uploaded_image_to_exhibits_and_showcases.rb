class AddUploadedImageToExhibitsAndShowcases < ActiveRecord::Migration
  def change
    add_attachment :exhibits, :uploaded_image

    add_attachment :showcases, :uploaded_image
  end
end
