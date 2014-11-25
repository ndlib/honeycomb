require 'rails_helper'

describe AssignUserToCollection do
  let(:collection) { double(Collection, id: 1) }
  let(:user) { double(User, id: 1, username: 'test', first_name: 'Test', last_name: 'Test', display_name: 'Test Test') }
  subject { described_class.call(collection, user) }

  it "to return a CollectionUser when save is true" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(true)
    expect(subject).to be_kind_of(CollectionUser)
  end

  it "to return false when save is false" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(false)
    expect(subject).to be(false)
  end

  it "to set the collection id" do
    result = described_class.call(collection, user)
    expect(result.collection_id).to eq collection.id
  end

  it "to set the user id" do
    result = described_class.call(collection, user)
    expect(result.user_id).to eq user.id 
  end

end
