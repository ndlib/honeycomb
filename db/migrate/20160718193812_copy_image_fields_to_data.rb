class CopyImageFieldsToData < ActiveRecord::Migration
  def up
    Image.all.each do |image|
      image.data = image.to_json(except: [:id, :collection_id, :created_at, :updated_at, :data, :media_type])
      image.type = "Image"
      image.save
    end
  end
end

class Image < ActiveRecord::Base
  serialize :json_response, Hash
end
