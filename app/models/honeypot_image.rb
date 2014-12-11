class HoneypotImage < ActiveRecord::Base
  serialize :json_response, Hash

  belongs_to :item

  validates :title, :host, :json_response, presence: true

  before_validation :set_values_from_json_response

  def style(style_name)
    styles[style_name]
  end

  def styles
    @styles ||= build_styles
  end

  def json_response=(*args)
    super(*args)
    set_values_from_json_response
  end

  def image_json
    if json_response.present?
      json_response["image"]
    else
      {}
    end
  end

  private

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

    def set_values_from_json_response
      self.title = image_json["title"]
      self.host = image_json["host"]
    end
end
