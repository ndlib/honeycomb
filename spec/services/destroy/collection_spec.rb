require "rails_helper"

describe Destroy::Collection do
  describe "#cascade" do
    let(:destroy_item) { instance_double(Destroy::Item, cascade!: nil) }
    let(:destroy_showcase) { instance_double(Destroy::Showcase, force_cascade!: nil) }
    let(:destroy_page) { instance_double(Destroy::Page, force_cascade!: nil) }
    let(:destroy_collection_user) { instance_double(Destroy::CollectionUser, cascade!: nil) }
    let(:destroy_collection_configuration) { instance_double(Destroy::CollectionConfiguration, cascade!: nil) }
    let(:subject) do
      Destroy::Collection.new(destroy_collection_configuration: destroy_collection_configuration,
                              destroy_collection_user: destroy_collection_user,
                              destroy_item: destroy_item,
                              destroy_showcase: destroy_showcase,
                              destroy_page: destroy_page)
    end
    let(:showcase) { instance_double(Showcase, destroy!: true) }
    let(:item) { instance_double(Item, destroy!: true, sections: [], children: []) }
    let(:page) { instance_double(Page, destroy!: true) }
    let(:collection_configuration) { instance_double(CollectionConfiguration, destroy!: true) }
    let(:collection) do
      instance_double(Collection,
                      collection_configuration: collection_configuration,
                      collection_users: [collection_user, collection_user],
                      showcases: [showcase, showcase],
                      items: [item, item],
                      pages: [page, page],
                      destroy!: true)
    end
    let(:collection_user) { instance_double(CollectionUser) }

    it "calls DestroyItem.cascade on all associated items" do
      expect(destroy_item).to receive(:cascade!).with(item: item).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyShowcase.cascade on all associated showcases" do
      expect(destroy_showcase).to receive(:force_cascade!).with(showcase: showcase).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyPage.cascade on all associated pages" do
      expect(destroy_page).to receive(:force_cascade!).with(page: page).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyShowcase then DestroyItem to prevent FK constraints on Item->Section" do
      expect(destroy_showcase).to receive(:force_cascade!).with(showcase: showcase).at_least(:once).ordered
      expect(destroy_item).to receive(:cascade!).with(item: item).at_least(:once).ordered
      subject.cascade!(collection: collection)
    end

    it "calls DestroyCollectionUser.cascade on all associated collection_users" do
      expect(destroy_collection_user).to receive(:cascade!).with(collection_user: collection_user).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyCollectionConfiguration.cascade on the associated collection_configuration" do
      expect(destroy_collection_configuration).to receive(:cascade!).with(collection_configuration: collection_configuration).once
      subject.cascade!(collection: collection)
    end

    it "destroys the Collection" do
      expect(collection).to receive(:destroy!)
      subject.cascade!(collection: collection)
    end
  end

  context "cascade transaction" do
    let(:destroy_item) { Destroy::Item.new }
    let(:destroy_showcase) { Destroy::Showcase.new }
    let(:destroy_collection_user) { Destroy::CollectionUser.new }
    let(:destroy_page) { Destroy::Page.new }
    let(:destroy_collection_configuration) { Destroy::CollectionConfiguration.new }
    let(:subject) do
      Destroy::Collection.new(destroy_collection_configuration: destroy_collection_configuration,
                              destroy_collection_user: destroy_collection_user,
                              destroy_item: destroy_item,
                              destroy_showcase: destroy_showcase,
                              destroy_page: destroy_page)
    end
    let(:collection) { FactoryGirl.create(:collection) }
    let(:showcase) { FactoryGirl.create(:showcase, collection_id: collection.id) }
    let(:user) { FactoryGirl.create(:default_user) }
    let(:collection_configuration) { FactoryGirl.create(:collection_configuration, id: 1, collection_id: collection.id) }
    let(:collection_users) do
      [FactoryGirl.create(:collection_user, id: 1, collection_id: collection.id),
       FactoryGirl.create(:collection_user, id: 2, collection_id: collection.id)]
    end
    let(:items) do
      [FactoryGirl.create(:item, id: 1, collection_id: collection.id, user_defined_id: "one"),
       FactoryGirl.create(:item, id: 2, collection_id: collection.id, user_defined_id: "two")]
    end
    let(:pages) do
      [FactoryGirl.create(:page, id: 1, collection_id: collection.id),
       FactoryGirl.create(:page, id: 2, collection_id: collection.id)]
    end

    before(:each) do
      allow_any_instance_of(Metadata::Fields).to receive(:valid?).and_return(true)
      user
      collection
      collection_configuration
      showcase
      items
      pages
      collection_users
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      items_still_exist!
      pages_still_exist!
      expect { showcase.reload }.not_to raise_error
      expect { collection_configuration.reload }.not_to raise_error
      expect { collection.reload }.not_to raise_error
    end

    def items_still_exist!
      items.each do |item|
        expect { item.reload }.not_to raise_error
      end
    end

    def pages_still_exist!
      pages.each do |page|
        expect { page.reload }.not_to raise_error
      end
    end

    def collection_users_still_exist!
      collection_users.each do |collection_user|
        expect { collection_user.reload }.not_to raise_error
      end
    end

    it "rolls back if an error occurs with Destroy::CollectionUser" do
      # Throw error on second object to allow first one to get deleted
      allow(collection).to receive(:collection_users).and_return(collection_users)
      allow(collection_users[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Item" do
      # Throw error on second object to allow first one to get deleted
      allow(collection).to receive(:items).and_return(items)
      allow(items[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Showcase" do
      allow(destroy_showcase).to receive(:force_cascade!).with(showcase: showcase).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Page" do
      # Throw error on second object to allow first one to get deleted
      allow(collection).to receive(:pages).and_return(pages)
      allow(pages[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::CollectionConfiguration" do
      allow(destroy_collection_configuration).to receive(:cascade!).with(collection_configuration: collection_configuration).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Collection.destroy!" do
      allow(collection).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end
  end
end
