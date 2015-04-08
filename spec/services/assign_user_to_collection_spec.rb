require 'rails_helper'

describe AssignUserToCollection do
  let(:collection) { double(Collection, id: 1) }
  let(:user) { double(User, id: 1, username: 'test', first_name: 'Test', last_name: 'Test', display_name: 'Test Test') }
  subject { described_class.new(collection, user) }

  describe '#assign!' do
    it "to return a CollectionUser when save is true" do
      expect_any_instance_of(CollectionUser).to receive("save").and_return(true)
      expect(subject.assign!).to be_kind_of(CollectionUser)
    end

    it "to return false when save is false" do
      expect_any_instance_of(CollectionUser).to receive("save").and_return(false)
      expect(subject.assign!).to be(false)
    end

    it "to set the collection id" do
      result = subject.assign!
      expect(result.collection_id).to eq collection.id
    end

    it "to set the user id" do
      result = subject.assign!
      expect(result.user_id).to eq user.id
    end
  end

  describe 'blank user' do
    let(:user) { nil }

    it "returns false" do
      expect(subject.assign!).to be_falsy
    end
  end

  describe 'self' do
    subject { described_class }

    describe '#call' do
      it 'invokes assign! on a new instance' do
        expect_any_instance_of(described_class).to receive(:assign!).and_return(true)
        expect(subject.call(collection, user)).to be_truthy
      end
    end
  end

end
