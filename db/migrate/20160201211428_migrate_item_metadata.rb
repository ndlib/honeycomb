class MigrateItemMetadata < ActiveRecord::Migration
  def change
    Migration::ItemMetadataConverter.call
  end
end
