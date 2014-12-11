class HoneypotImage < ActiveRecord::Base
  serialize :json_response, Hash

  belongs_to :item

  validates :title, :width, :height, :host, :json_response, presence: true

  private
    def image_json
      if json_response.present?
        json_response["image"]
      else
        {}
      end
    end

    def get_key(key)
      image_json[key]
    end

    def styles_data
      get_key("styles") || {}
    end
end
