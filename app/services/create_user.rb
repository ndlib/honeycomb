class CreateUser
  attr_reader :user

  def self.call(user)
    new(user).create
  end

  def initialize(user)
    @user = user
  end

  def create
    user
  end

  private

  def user
    @user ||= User.find_for_authentication(@user)
  end
end
