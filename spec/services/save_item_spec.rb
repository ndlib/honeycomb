require "rails_helper"

RSpec.describe SaveItem, type: :model do
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
  subject { described_class.call(item, params) }
  let(:item) { Item.new }
  let(:page) { Page.new }
  let(:params) { { unique_id: "ad" } }
  let(:collection) { instance_double(Collection, collection_configuration: double) }

  before(:each) do
    # stub the call to the external service
    allow(SaveHoneypotImage).to receive(:call).and_return(true)
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(Index::Item).to receive(:index!).and_return(true)
    allow(item).to receive(:name).and_return("name")
    allow(item).to receive(:no_image!).and_return(nil)
    allow(CreateUserDefinedId).to receive(:call).and_return(true)
    allow(Metadata::Setter).to receive(:call).and_return(true)
    allow(FindOrCreateImage).to receive(:call).and_return(nil)
    allow_any_instance_of(Metadata::Fields).to receive(:valid?).and_return(true)
  end

  it "returns when the item save is successful" do
    expect(item).to receive(:save).at_least(:once).and_return(true)
    expect(subject).to be_kind_of(Item)
  end

  it "returns when the item save is not successful" do
    expect(item).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "uses the param cleaner before setting item attributes" do
    expect(ParamCleaner).to receive(:call).with(hash: params).ordered
    expect(item).to receive(:attributes=).with("unique_id" => "ad").ordered
    subject
  end

  it "sets the attributes of the item to be the passed in attributes " do
    expect(item).to receive(:attributes=).with("unique_id" => "ad")
    subject
  end

  it "removes the uploaded image from the params if the param is nil" do
    params[:uploaded_image] = nil
    allow(params).to receive(:with_indifferent_access).and_return(params)
    allow(item).to receive("attributes=")
    expect(params).to receive(:delete).with(:uploaded_image)

    subject
  end

  describe "unique_id" do
    before(:each) do
      allow(item).to receive(:save).and_return(true)
    end

    it "uses the CreateUniqueId service class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(item)
      subject
    end
  end

  describe "user_defined_id" do
    before(:each) do
      allow(item).to receive(:save).and_return(true)
    end

    it "uses the CreateUserDefinedId service class to generate the id" do
      expect(CreateUserDefinedId).to receive(:call).with(item)
      subject
    end
  end

  describe "index_item" do
    let(:item) { Item.new(unique_id: "12345") }

    before do
      allow(item).to receive(:save).and_return(true)
    end

    it "indexes" do
      expect(Index::Item).to receive(:index!).and_call_original
      subject
    end
  end

  describe "fix_image_references" do
    let(:item) { Item.new(unique_id: "12345", pages: [page]) }

    before do
      allow(item).to receive(:save).and_return(true)
    end

    it "replaces image references" do
      expect(ReplacePageItem).to receive(:call).once.and_return(true)
      subject
    end
  end

  describe "image processing" do
    it "returns the item if the image was updated" do
      params[:uploaded_image] = upload_image
      allow(item).to receive(:save).and_return(true)
      expect(subject).to eq(item)
    end

    it "calls FindOrCreateImage if the image is changed" do
      params[:uploaded_image] = upload_image
      expect(FindOrCreateImage).to receive(:call).and_return(nil)
      allow(item).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: item).and_return(true)
      subject
    end

    it "FindOrCreateImage is not called if the image is not changed" do
      params[:uploaded_image] = nil
      expect(FindOrCreateImage).not_to receive(:call)
      subject
    end
  end

  context "no name on a new record" do
    let(:params) { {} }

    before(:each) do
      allow(item).to receive(:name).and_return(nil)
      allow(item).to receive(:uploaded_image_file_name).and_return("test.jpg")
    end

    it "sets the name to be the uploaded filename when the item is a new record?" do
      params[:uploaded_image] = upload_image
      expect(GenerateNameFromFilename).to receive(:call).with("test.jpg").at_least(:once).and_return("Filename")
      subject
    end

    it "calls the metadata setter to set the name" do
      params[:uploaded_image] = upload_image
      allow(item).to receive(:description).and_return("")
      allow(GenerateNameFromFilename).to receive(:call).and_return("Filename")
      expect(Metadata::Setter).to receive(:call).with(item, "name" => "Filename")
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
