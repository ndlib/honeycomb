class User < ActiveRecord::Base

  has_many :collection_users
  has_many :collections, :through => :collection_users
  
  devise :cas_authenticatable, :trackable

  before_validation :map_user

  validates :username, :email, :uniqueness => true
  validates_presence_of :username

  scope :username, lambda { | username |  where(username: username) }

  def name
    "#{first_name} #{last_name}"
  end

  def username
    self[:username].to_s.downcase.strip
  end

  protected

  def map_user
    MapUserToApi.call(self)
  end

end
