class MapUserToApi
  attr_reader :user

  def self.call(user)
    new(user).map!
  end

  def initialize(user)
    @user = user
  end

  def map!
    map_attributes
    user
  rescue StandardError => exception
    Raven.capture_exception(exception)
    user
  end

  private

  def map_attributes
    [:first_name, :last_name, :email, :display_name].each do |field|
      value = send(field)
      if value.present?
        user.send("#{field}=", value)
      end
    end
  end

  def api_attributes
    @api_attributes ||= HesburghAPI::PersonSearch.find(user.username)
  end

  def first_name
    fetch("first_name")
  end

  def last_name
    fetch("last_name")
  end

  def display_name
    fetch("full_name")
  end

  def email
    contact_information.fetch("email", nil)
  end

  def contact_information
    fetch("contact_information", {})
  end

  def fetch(key, default = nil)
    api_attributes.fetch(key.to_s, default)
  end
end
