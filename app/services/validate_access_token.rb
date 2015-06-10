class ValidateAccessToken
  attr_reader :session, :token

  def self.call(session, token)
    new(session, token).validate!
  end

  def initialize(session, token)
    @session = session
    @token = token
  end

  def validate!
    @session[:token] == @token
  end
  
end
