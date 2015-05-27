class AddCopyrightToExhibits < ActiveRecord::Migration
  def change
    add_column :exhibits, :copyright, :text
  end
end
