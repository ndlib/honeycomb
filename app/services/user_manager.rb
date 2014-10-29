class UserManager
  attr_reader :user

  def self.call(user)
    new(user).save
  end

  def initialize(user)
    @user = user
  end

  def self.create(username)
    @user = User.find_for_authentication(username)
    if @user.nil?
      @user = User.new(username)
    end
    @user.set_admin!
  end

  def self.save
    @user.save
  end

  def self.fetch_attributes(username)
    attributes = JSON.parse(HesburghAPI::PersonSearch.find(username).to_json)
  end

  def self.set_attributes(user, attributes)
    user.first_name = attributes['data']['first_name']
    user.last_name = attributes['data']['last_name']
    user.email = attributes['data']['contact_information']['email']
    user.display_name = attributes['data']['full_name']
  end

  private

end
