require "store_enum"

class Audio < Media
  store_accessor :data, :json_response
  extend StoreEnum
  store_enum :data, status: { allocated: 0, ready: 1 }

  has_paper_trail
end
