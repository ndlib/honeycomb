class CreateUser
  attr_reader :user, :params

  def self.call(user, params)
    new(user, params).create!
  end

  def initialize(user, params)
    @user = user
    @params = params
  end

  def create!
    # devise
    user.attributes = params
    if user.save
      user
    else
      false
    end
  end
end
