class User < ActiveRecord::Base

  has_many :collections_users
  has_many :collections, :through => :collections_users
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  before_validation :map_user
  # Setup accessible (or protected) attributes for your model

  validates :username, :email, :uniqueness => true
  validates_presence_of :email, :username, :first_name, :last_name, :display_name

  scope :username, lambda { | username |  where(username: username) }

  def name
    "#{first_name} #{last_name}"
  end

  def username
    self[:username].to_s.downcase.strip
  end

  def admin?
    self.admin
  end

  protected
  def map_user
    MapUserToApi.call(self)
  end
end
