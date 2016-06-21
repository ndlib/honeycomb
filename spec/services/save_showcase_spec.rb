require "rails_helper"

RSpec.describe SaveShowcase, type: :model do
  subject { described_class.call(showcase, params) }
  let(:showcase) { instance_double(Showcase, "attributes=" => true, collection_id: 1, "image=" => true) }
  let(:params) { { name_line_1: "name_line_1" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(showcase).to receive(:save).and_return(true)
  end

  it "returns when the showcase save is successful" do
    expect(showcase).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the showcase save is not successful" do
    expect(showcase).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the showcase to be the passed in attributes " do
    expect(showcase).to receive(:attributes=).with(params)
    subject
  end

  describe "image processing" do
    it "returns the true if the image was updated" do
      params[:uploaded_image] = upload_image
      allow(showcase).to receive(:save).and_return(true)
      expect(subject).to eq(true)
    end

    it "calls FindOrCreateImage if the image is changed" do
      params[:uploaded_image] = upload_image
      expect(FindOrCreateImage).to receive(:call).and_return(nil)
      allow(showcase).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: showcase).and_return(true)
      subject
    end

    it "FindOrCreateImage is not called if the image is not changed" do
      params[:uploaded_image] = nil
      expect(FindOrCreateImage).not_to receive(:call)
      subject
    end
  end

  describe "unique_id" do
    before(:each) do
      allow(showcase).to receive(:save).and_return(true)
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(showcase)
      subject
    end
  end
end
