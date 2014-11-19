require 'rails'

describe AssignUserToCollection do
  subject { described_class.call(collection, user) }
  let(:collection) { double(Collection, id: 1) }
  let(:user) { double(User, id: 1) }

  it "to return a CollectionUser when save is true" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(true)
    expect(subject).to be_kind_of(CollectionUser)
  end

  it "to return false when save is false" do
    expect_any_instance_of(CollectionUser).to receive("save").and_return(false)
    expect(subject).to be(false)
  end

#  it "to set the collection id" do
#    expect_any_instance_of(CollectionUser).to receive(:collection_id=).with(collection.id)
#    subject
#  end

  it "to set the user id" do
    expect_any_instance_of(CollectionUser).to receive(:user_id=).with(user.id)
    described_class.call(collection, user)
  end

end
