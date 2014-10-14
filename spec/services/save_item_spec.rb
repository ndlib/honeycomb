require "rails_helper"

RSpec.describe SaveItem, type: :model do
  subject { described_class.call(item, params) }
  let(:item) { double(Item, "attributes=" => true, save: true )}
  let(:params) { { title: 'title' } }

  it "returns when the item save is successful" do
    item.stub(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the item save is not successful" do
    item.stub(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the item to be the passed in attributes " do
    expect(item).to receive(:attributes=).with(params)
    subject
  end

end
