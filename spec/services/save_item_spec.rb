require "rails_helper"

RSpec.describe SaveItem, type: :model do
  subject { described_class.call(item, params) }
  let(:item) { double(Item, "attributes=" => true, save: true, new_record?: false )}
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

  it "sets the title to be the uploaded filename when the item is a new record?" do
    expect(item).to receive(:new_record?).and_return(true)
    expect(item).to receive(:title).and_return("")
    expect(item).to receive(:image_file_name).and_return("filename")
    expect(item).to receive("title=").with('filename')

    subject
  end

  it "uses the existing title if it has a title " do
    expect(item).to receive(:new_record?).and_return(true)
    expect(item).to receive(:title).and_return("title")

    expect(item).to_not receive("title=")

    subject
  end


  it "does not set the title when it is not a new record " do
    expect(item).to_not receive("title=")

    subject
  end
end
