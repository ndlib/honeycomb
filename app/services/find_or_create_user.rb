class FindOrCreateUser
  attr_reader :username

  def self.call(username)
    new(username).find_or_create
  end

  def initialize(username)
    @username = username
  end

  def find_or_create
    user
  end

  private
  def user
    @user ||= User.where({username: username}).first
    if @user.nil?
      # begin
        @user = CreateUser.call(User.new(), {username: username})
      # rescue
      #   @user = false
      # end
    end
    @user
  end
end
