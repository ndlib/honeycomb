class UpdateTiledImages < ActiveRecord::Migration
  def change
    add_column(:tiled_images, :host, :string)
    add_column(:tiled_images, :path, :string)
    add_column(:tiled_images, :created_at, :datetime)
    add_column(:tiled_images, :updated_at, :datetime)
    remove_column(:tiled_images, :uri)
  end
end
