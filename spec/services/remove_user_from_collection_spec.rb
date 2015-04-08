require 'rails_helper'

describe RemoveUserFromCollection do
  subject { described_class.new(collection, user) }
  let(:collection) { double(Collection, id: 1) }
  let(:user) { double(User, id: 1) }

  before (:each) do
    AssignUserToCollection.call(collection, user)
  end
  it "deletes the collection_user" do
    expect_any_instance_of(CollectionUser).to receive(:destroy)
    subject.delete!
  end
end
