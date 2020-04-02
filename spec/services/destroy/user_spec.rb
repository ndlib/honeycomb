require "rails_helper"

describe Destroy::User do
  let(:user) { instance_double(User, collection_users: [collection_user, collection_user], destroy!: true) }
  let(:collection) { instance_double(Collection) }
  let(:collection_user) { instance_double(CollectionUser) }
  let(:destroy_collection_user) { instance_double(Destroy::CollectionUser, cascade!: nil) }
  let(:subject) { Destroy::User.new(destroy_collection_user: destroy_collection_user) }

  describe "#destroy" do
    it "destroys the User" do
      expect(user).to receive(:destroy!)
      subject.destroy!(user: user)
    end
  end

  describe "#cascade" do
    it "calls DestroyCollectionUser on all associated collection_users" do
      expect(destroy_collection_user).to receive(:cascade!).with(collection_user: collection_user).twice
      subject.cascade!(user: user)
    end

    it "destroys the User" do
      expect(user).to receive(:destroy!)
      subject.cascade!(user: user)
    end
  end

  context "cascade transaction" do
    let(:destroy_collection_user) { Destroy::CollectionUser.new }
    let(:subject) { Destroy::User.new(destroy_collection_user: destroy_collection_user) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:user) { FactoryGirl.create(:default_user) }
    let(:collection_users) do
      [FactoryGirl.create(:collection_user, id: 1, collection_id: collection.id),
       FactoryGirl.create(:collection_user, id: 2, collection_id: collection.id)]
    end

    before(:each) do
      user
      collection_users
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      collection_users.each do |collection_user|
        expect { collection_user.reload }.not_to raise_error
      end
      expect { user.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::CollectionUser" do
      # Throw error on second object to allow first one to get deleted
      allow(user).to receive(:collection_users).and_return(collection_users)
      allow(collection_users[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(user: user) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with User.destroy!" do
      allow(user).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(user: user) }.to raise_error("error")
      data_still_exists!
    end
  end
end
