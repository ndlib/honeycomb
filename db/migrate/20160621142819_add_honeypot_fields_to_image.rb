class AddHoneypotFieldsToImage < ActiveRecord::Migration
  def change
    add_column :images, :json_response, :text
    add_column :images, :status, :integer, default: 0
  end
end
