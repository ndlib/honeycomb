require "store_enum"

class Audio < Media
  extend StoreEnum
  store_enum :data, status: { allocated: 0, ready: 1 }
  store_accessor :data, :file_name, :json_response
end
