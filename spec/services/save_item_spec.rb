require "rails_helper"

RSpec.describe SaveItem, type: :model do
  subject { described_class.call(item, params) }
  let(:item) { Item.new }
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

  it "removes the image from the params if the image param is nil" do
    params[:image] = nil
    expect(params).to receive(:delete).with(:image)

    subject
  end

  it "uses the sortable title converter to convert the sortable title" do
    expect(SortableTitleConverter).to receive(:convert).with("title")
    subject
  end

  context "no title on a new record" do
    let(:params) { {} }

    it "sets the title to be the uploaded filename when the item is a new record?" do
      item.stub(:image_file_name).and_return('filename')
      expect(item).to receive("title=").with('filename')

      subject
    end
  end

  context "existing title on a new record" do

    it "does not set the title to the uploaded file name" do
      item.stub(:image_file_name).and_return('filename')
      item.stub(:title).and_return("title")
      expect(item).to_not receive("title=").with('filename')

      subject
    end
  end

  context "not a new record" do

    it "does not set the title when it is not a new record " do
      item.stub(:image_file_name).and_return('filename')
      item.stub(:new_record?).and_return(false)
      expect(item).to_not receive("title=").with('filename')

      subject
    end
  end
end
