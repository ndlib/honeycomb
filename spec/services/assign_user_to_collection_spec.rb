require 'rails_helper'

describe AssignUserToCollection do
  subject { described_class.call(collection, user) }
  let(:collection) { double(Collection, id: 2) }
  let(:user) { double(User, id: 4) }

  it "to return a CollectionUser when save is true" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(true)
    expect(subject).to be_kind_of(CollectionUser)
  end

  it "to return false when save is false" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(false)
    expect(subject).to be(false)
  end

  it "to set the collection id" do
    collection_user = described_class.call(collection, user)
    expect(collection_user.collection_id).to eq(collection.id)
  end

  it "to set the user id" do
    collection_user = described_class.call(collection, user)
    expect(collection_user.user_id).to eq(user.id)
  end

end
