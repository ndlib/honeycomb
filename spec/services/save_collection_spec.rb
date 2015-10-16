require "rails_helper"

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { double(Collection, id: "id", "attributes=" => true, save: true) }
  let(:params) { { name_line_1: "name_line_1" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(EnsureCollectionHasExhibit).to receive(:call).and_return(true)
  end

  it "returns when the collection save is successful" do
    expect(collection).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the collection save is not successful" do
    expect(collection).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the collection to be the passed in attributes " do
    expect(collection).to receive(:attributes=).with(params)
    subject
  end

  describe "unique_id" do
    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(collection)
      subject
    end
  end

  describe "image processing" do
    it "Queues image processing if the image was updated" do
      params[:uploaded_image] = upload_image
      expect(collection).to receive(:save).and_return(true)
      expect(QueueJob).to receive(:call).with(ProcessImageJob, object: collection).and_return(true)
      subject
    end

    it "is not called if the image is not changed" do
      params[:uploaded_image] = nil
      expect(collection).to receive(:save).and_return(true)
      expect(QueueJob).to_not receive(:call)
      subject
    end
  end
end
