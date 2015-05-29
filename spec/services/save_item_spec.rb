require "rails_helper"

RSpec.describe SaveItem, type: :model do
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
  subject { described_class.call(item, params) }
  let(:item) { Item.new }
  let(:params) { { name: "name" } }

  before(:each) do
    # stub the call to the external service
    allow(SaveHoneypotImage).to receive(:call).and_return(true)
    allow(CreateUniqueId).to receive(:call).and_return(true)
  end

  it "returns when the item save is successful" do
    expect(item).to receive(:save).and_return(true)
    expect(subject).to be_kind_of(Item)
  end

  it "returns when the item save is not successful" do
    expect(item).to receive(:save).and_return(false)
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

  it "uses the sortable name converter to convert the sortable name" do
    expect(SortableNameConverter).to receive(:convert).with("name")
    subject
  end

  describe "unique_id" do
    before(:each) do
      allow(item).to receive(:save).and_return(true)
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(item)
      subject
    end

    it "does not call create unique_id if the item does not save" do
      allow(item).to receive(:save).and_return(false)
      expect(CreateUniqueId).to_not receive(:call).with(item)
      subject
    end
  end

  describe "update honeypot image" do
    it "calls SaveHoneypotImage if the image was updated" do
      params[:image] = upload_image
      expect(item).to receive(:save).and_return(true)
      expect(SaveHoneypotImage).to receive(:call).and_return(true)
      expect(subject).to eq(item)
    end

    it "returns false if the honeypot update fails" do
      params[:image] = upload_image
      expect(item).to receive(:save).and_return(true)
      expect(SaveHoneypotImage).to receive(:call).and_return(false)
      expect(subject).to be_falsy
    end

    it "is not called if the image is not changed" do
      params[:image] = nil
      expect(item).to receive(:save).and_return(true)
      expect(SaveHoneypotImage).to_not receive(:call)
      expect(subject).to eq(item)
    end
  end

  context "no name on a new record" do
    let(:params) { {} }

    it "sets the name to be the uploaded filename when the item is a new record?" do
      expect(GenerateNameFromFilename).to receive(:call).at_least(:once).and_return("Filename")
      expect(item).to receive("name=").with("Filename")

      subject
    end
  end

  context "existing name on a new record" do
    it "does not set the name to the uploaded file name" do
      expect(GenerateNameFromFilename).to_not receive(:call)
      expect(item).to receive(:name).at_least(:once).and_return("name")
      expect(item).to_not receive("name=").with("Filename")

      subject
    end
  end

  context "not a new record" do
    it "does not set the name when it is not a new record " do
      expect(GenerateNameFromFilename).to_not receive(:call)
      expect(item).to receive(:new_record?).at_least(:once).and_return(false)
      expect(item).to_not receive("name=").with("filename")

      subject
    end
  end
end
