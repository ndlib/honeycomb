class CopyCollectionIdToShowcase < ActiveRecord::Migration
  def up
    execute "UPDATE showcases INNER JOIN exhibits ON exhibits.id = showcases.exhibit_id
             SET showcases.collection_id = exhibits.collection_id;"
  end

  def down
  end
end
