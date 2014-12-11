class HoneypotImage < ActiveRecord::Base
  serialize :json_response, Hash

  belongs_to :item

  validates :title, :width, :height, :host, :json_response, presence: true

  def style(style_name)
    styles[style_name]
  end

  def styles
    @styles ||= build_styles
  end

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

    def build_styles
      {}.with_indifferent_access.tap do |hash|
        styles_data.each do |name, data|
          hash[name.to_sym] = HoneypotImageStyle.new(data)
        end
      end
    end
end
