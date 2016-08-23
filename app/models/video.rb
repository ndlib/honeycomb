require "store_enum"

class Video < Media
  extend StoreEnum
  store_enum :data, status: { allocated: 0, ready: 1 }
  store_accessor :data, :file_name, :thumbnail_url, :json_response
end
