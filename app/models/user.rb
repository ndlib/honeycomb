class User < ActiveRecord::Base
  has_many :collection_users
  has_many :collections, through: :collection_users

  devise :omniauthable, omniauth_providers: [:oktaoauth]

  before_validation :map_user

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true

  scope :username, ->(username) {  where(username: username) }

  has_paper_trail

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
