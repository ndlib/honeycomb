require "rails_helper"

describe Destroy::Collection do
  describe "#cascade" do
    let(:destroy_item) { instance_double(Destroy::Item, cascade!: nil) }
    let(:destroy_showcase) { instance_double(Destroy::Showcase, cascade!: nil) }
    let(:destroy_collection_user) { instance_double(Destroy::CollectionUser, cascade!: nil) }
    let(:subject) { Destroy::Collection.new(destroy_collection_user: destroy_collection_user, destroy_item: destroy_item, destroy_showcase: destroy_showcase) }
    let(:showcase) { instance_double(Showcase, destroy!: true) }
    let(:item) { instance_double(Item, destroy!: true, sections: [], children: []) }
    let(:collection) do
      instance_double(Collection,
                      collection_users: [collection_user, collection_user],
                      showcases: [showcase, showcase],
                      items: [item, item],
                      destroy!: true)
    end
    let(:collection_user) { instance_double(CollectionUser) }

    it "calls DestroyItem.cascade on all associated items" do
      expect(destroy_item).to receive(:cascade!).with(item: item).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyShowcase.cascade on all associated showcases" do
      expect(destroy_showcase).to receive(:cascade!).with(showcase: showcase).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyShowcase then DestroyItem to prevent FK constraints on Item->Section" do
      expect(destroy_showcase).to receive(:cascade!).with(showcase: showcase).at_least(:once).ordered
      expect(destroy_item).to receive(:cascade!).with(item: item).at_least(:once).ordered
      subject.cascade!(collection: collection)
    end

    it "calls DestroyCollectionUser.cascade on all associated collection_users" do
      expect(destroy_collection_user).to receive(:cascade!).with(collection_user: collection_user).twice
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
    let(:subject) { Destroy::Collection.new(destroy_collection_user: destroy_collection_user, destroy_item: destroy_item, destroy_showcase: destroy_showcase) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:showcase) { FactoryGirl.create(:showcase, collection_id: collection.id) }
    let(:user) { FactoryGirl.create(:user) }
    let(:collection_users) do
      [FactoryGirl.create(:collection_user, id: 1, collection_id: collection.id),
       FactoryGirl.create(:collection_user, id: 2, collection_id: collection.id)]
    end
    let(:items) do
      [FactoryGirl.create(:item, id: 1, collection_id: collection.id, user_defined_id: "one"),
       FactoryGirl.create(:item, id: 2, collection_id: collection.id, user_defined_id: "two")]
    end

    before(:each) do
      user
      collection
      showcase
      items
      collection_users
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      items.each do |item|
        expect { item.reload }.not_to raise_error
      end
      collection_users.each do |collection_user|
        expect { collection_user.reload }.not_to raise_error
      end
      expect { showcase.reload }.not_to raise_error
      expect { collection.reload }.not_to raise_error
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
      allow(destroy_showcase).to receive(:cascade!).with(showcase: showcase).and_raise("error")
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
