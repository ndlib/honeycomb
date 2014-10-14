class AddPaperclipFiles < ActiveRecord::Migration
  def change
    add_attachment :items, :image
  end
end
