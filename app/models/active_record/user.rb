class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  before_validation :fetch_attributes_from_api

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

  # roles
  def has_role?(role_sym)
    roles.any? { |r| r.name.split.join.to_s.underscore.to_sym == role_sym }
  end


  def admin?
    self.admin
  end

  def wse_admin?
    ['rfox2', 'jhartzle'].include?(self.username)
  end

  def set_admin!
    self.admin = true
    self.save!
  end

  def revoke_admin!
    self.admin = false
    self.save!
  end
  private

  def fetch_attributes_from_api
    begin
      attributes = UserManager.fetch_attributes(username)
      if attributes['data']['contact_information']['email'].nil?
        errors.add(:username, "No person found with this username.")
      else
        begin
          UserManager.set_attributes(self, attributes)
        rescue
          errors.add(:username, "There is a problem with this user in the api.")
        end
      end
    rescue
      errors.add(:username, "Could not connect to the api.")
    end
  end
end
