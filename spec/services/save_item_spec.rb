require "rails_helper"

RSpec.describe SaveItem, type: :model do
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
  subject { described_class.call(item, params) }
  let(:item) { Item.new }
  let(:page) { Page.new }
  let(:params) { { name: "name" } }

  before(:each) do
    # stub the call to the external service
    allow(SaveHoneypotImage).to receive(:call).and_return(true)
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(Index::Item).to receive(:index!).and_return(true)
    allow(item).to receive(:name).and_return("name")
    allow(item).to receive(:no_image!).and_return(nil)
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
    expect(item).to receive(:attributes=).with(params).ordered
    subject
  end

  it "sets the attributes of the item to be the passed in attributes " do
    expect(item).to receive(:attributes=).with(params)
    subject
  end

  it "removes the uploaded image from the params if the param is nil" do
    params[:uploaded_image] = nil
    expect(params).to receive(:delete).with(:uploaded_image)

    subject
  end

  it "uses the sortable name converter to convert the sortable name" do
    expect(SortableNameConverter).to receive(:convert).with("name")
    subject
  end

  describe "metadata cleaning" do
    it "calls the metadata cleaner" do
      expect(MetadataInputCleaner).to receive(:call)
      subject
    end
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
    it "sets the invalid state when the class receives a sneakers connection error" do
      params[:uploaded_image] = upload_image
      allow(item).to receive(:image_processing!).and_return(true)
      allow(item).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: item).and_raise(Bunny::TCPConnectionFailedForAllHosts)
      expect(item).to receive(:image_unavailable!)
      subject
    end

    it "Queues image processing if the image was updated" do
      params[:uploaded_image] = upload_image
      allow(item).to receive(:image_processing!).and_return(true)
      allow(item).to receive(:save).and_return(true)
      expect(QueueJob).to receive(:call).with(ProcessImageJob, object: item).and_return(true)
      subject
    end

    it "returns the item if the image was updated" do
      params[:uploaded_image] = upload_image
      allow(item).to receive(:image_processing!).and_return(true)
      allow(item).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: item).and_return(true)
      expect(subject).to eq(item)
    end

    it "sets the image status to processing if the image was updated" do
      params[:uploaded_image] = upload_image
      expect(item).to receive(:image_processing!).and_return(true)
      allow(item).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: item).and_return(true)
      subject
    end

    it "is not called if the image is not changed" do
      params[:uploaded_image] = nil
      allow(item).to receive(:save).and_return(true)
      expect(QueueJob).to_not receive(:call)
      subject
    end

    it "returns the item even if the image is not changed" do
      params[:uploaded_image] = nil
      allow(item).to receive(:save).and_return(true)
      expect(subject).to eq(item)
    end

    it "sets the state to no image if there is no uploaded image and the item is in the error state" do
      # error state currently because it is the deault state. at some point it should be changed to no image.
      params[:uploaded_image] = nil
      allow(item).to receive(:image_unavailable?).and_return(true)
      allow(item).to receive(:save).and_return(true)
      expect(item).to receive(:no_image!)
      subject
    end
  end

  context "no name on a new record" do
    let(:params) { {} }

    it "sets the name to be the uploaded filename when the item is a new record?" do
      allow(item).to receive(:name).and_return("")
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
