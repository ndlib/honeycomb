class MapUserToApi
  attr_reader :user

  def self.call(user)
    new(user).map!
  end

  def initialize(user)
    @user = user
  end

  def map!
    user = User.new
    user.username = @user["username"]
    user.first_name = api_attributes['data']['first_name']
    user.last_name = api_attributes['data']['last_name']
    user.email = api_attributes['data']['contact_information']['email']
    user.display_name = api_attributes['data']['full_name']
    user
  end

  private

  def api_attributes
    @api_attributes ||= JSON.parse(HesburghAPI::PersonSearch.find(@user["username"]).to_json)
  end

end
