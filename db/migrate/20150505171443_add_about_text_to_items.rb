class AddAboutTextToItems < ActiveRecord::Migration
  def change
    add_column :exhibits, :about, :text
  end
end
