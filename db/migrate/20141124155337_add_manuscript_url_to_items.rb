class AddManuscriptUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :manuscript_url, :string
  end
end
