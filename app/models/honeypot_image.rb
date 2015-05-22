class HoneypotImage < ActiveRecord::Base
  serialize :json_response, Hash

  belongs_to :item
  belongs_to :showcase
  belongs_to :exhibit

  validates :name, :json_response, presence: true

  before_validation :set_values_from_json_response

  def json_response=(*args)
    super(*args)
    set_values_from_json_response
  end

  def url
    get_key("@id") || get_key("href")
  end

  def image_json
    if json_response.present?
      json_response["image"] || json_response
    else
      {}
    end
  end

  private

  def get_key(key)
    image_json[key]
  end

  def set_values_from_json_response
    self.name = get_key("name")
  end
end
