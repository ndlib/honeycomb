class MapUserToApi
  attr_reader :user

  def self.call(user)
    new(user).map!
  end

  def initialize(user)
    @user = user
  end

  def map!
    user.first_name = api_attributes['first_name']
    user.last_name = api_attributes['last_name']
    user.email = api_attributes['contact_information']['email']
    user.display_name = api_attributes['full_name']
    user
  end

  private

  def api_attributes
    @api_attributes ||= HesburghAPI::PersonSearch.find(user.username)
  end

end
