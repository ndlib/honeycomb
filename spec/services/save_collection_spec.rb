require "rails_helper"

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { Collection.new }
  let(:params) { { title: 'title' } }

  it "returns when the collection save is successful" do
    expect(collection).to receive(:save).and_return(true)
    expect(subject).to be_kind_of(Collection)
  end

  it "returns when the collection save is not successful" do
    expect(collection).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the collection to be the passed in attributes " do
    expect(collection).to receive(:attributes=).with(params)
    subject
  end
end