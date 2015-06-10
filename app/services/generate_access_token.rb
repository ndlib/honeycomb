class GenerateAccessToken
  attr_reader :byte_length, :token

  def self.call
    new(30).token
  end

  def initialize(byte_length)
    @byte_length = byte_length
    @token = generate_token
  end

  private

  def generate_token
    SecureRandom.urlsafe_base64(byte_length)
  end
end
