module Destroy
  class Collection

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_collection_configuration: nil, destroy_collection_user: nil, destroy_showcase: nil, destroy_item: nil, destroy_page: nil)
      @destroy_collection_configuration = destroy_collection_configuration || Destroy::CollectionConfiguration.new
      @destroy_collection_user = destroy_collection_user || Destroy::CollectionUser.new
      @destroy_showcase = destroy_showcase || Destroy::Showcase.new
      @destroy_item = destroy_item || Destroy::Item.new
      @destroy_page = destroy_page || Destroy::Page.new
    end

    # Destroy the object only
    def destroy!(collection:)
      collection.destroy!
    end

    # Destroys this object and all associated objects.
    def cascade!(collection: collection)
      ActiveRecord::Base.transaction do
        collection.collection_users.each do |child|
          destroy_collection_user.cascade!(collection_user: child)
        end
        collection.showcases.each do |child|
          destroy_showcase.force_cascade!(showcase: child)
        end
        collection.items.each do |child|
          destroy_item.cascade!(item: child)
        end
        collection.pages.each do |child|
          @destroy_page.force_cascade!(page: child)
        end
        if collection.collection_configuration
          @destroy_collection_configuration.cascade!(collection_configuration: collection.collection_configuration)
        end
        collection.destroy!
      end
    end

    private

    attr_reader :destroy_collection_user, :destroy_showcase, :destroy_item
  end
end
