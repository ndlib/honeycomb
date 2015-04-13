module Admin
  class AdministratorDecorator < Draper::Decorator
    def to_hash
      {
        id: id,
        username: username,
        name: name,
        removeUrl: destroy_path
      }
    end

    delegate :to_json, to: :to_hash

    delegate :id, to: :user

    def name
      user.display_name
    end

    delegate :username, to: :user

    def destroy_path
      h.admin_administrator_path(user.id)
    end

    private

    def user
      object
    end
  end
end
