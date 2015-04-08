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

    def to_json
      to_hash.to_json
    end

    def id
      user.id
    end

    def name
      user.display_name
    end

    def username
      user.username
    end

    def destroy_path
      h.admin_administrator_path(user.id)
    end

    private
      def user
        object
      end
  end
end
