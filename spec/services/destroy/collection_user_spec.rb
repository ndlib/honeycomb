require "rails_helper"

describe Destroy::CollectionUser do
  let(:collection_user) { instance_double(CollectionUser) }

  describe "#destroy" do
    it "destroys the CollectionUser" do
      expect(collection_user).to receive(:destroy!)
      subject.destroy!(collection_user: collection_user)
    end
  end

  describe "#cascade" do
    it "destroys the CollectionUser" do
      expect(collection_user).to receive(:destroy!)
      subject.cascade!(collection_user: collection_user)
    end
  end

  context "cascade transaction" do
    let(:user) { FactoryGirl.create(:default_user) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:collection_user) { FactoryGirl.create(:collection_user) }

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      expect { collection_user.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with CollectionUser.destroy!" do
      collection
      user
      allow(collection_user).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection_user: collection_user) }.to raise_error("error")
      data_still_exists!
    end
  end
end
