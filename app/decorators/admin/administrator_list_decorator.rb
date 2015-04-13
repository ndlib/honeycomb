module Admin
  class AdministratorListDecorator < Draper::CollectionDecorator
    def decorator_class
      AdministratorDecorator
    end

    def administrator_hashes
      decorated_collection.collect(&:to_hash)
    end
  end
end
