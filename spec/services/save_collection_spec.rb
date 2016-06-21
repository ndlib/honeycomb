require "rails_helper"

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { instance_double(Collection, id: "id", "attributes=" => true, save: true, url: nil, url_slug: nil, collection_configuration: double, "image=" => true) }
  let(:params) { { name_line_1: "name_line_1", url_slug: "Test Slug" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(collection).to receive(:url_slug=).with("test-slug")
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

  it "sets the url_slug to appropriate value if param is supplied" do
    expect(collection).to receive(:url_slug=).with("test-slug")
    subject
  end

  describe "unique_id" do
    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(collection)
      subject
    end
  end

  describe "image processing" do
    it "returns the true if the image was updated" do
      params[:uploaded_image] = upload_image
      allow(collection).to receive(:save).and_return(true)
      expect(subject).to eq(true)
    end

    it "calls FindOrCreateImage if the image is changed" do
      params[:uploaded_image] = upload_image
      expect(FindOrCreateImage).to receive(:call).and_return(nil)
      allow(collection).to receive(:save).and_return(true)
      allow(QueueJob).to receive(:call).with(ProcessImageJob, object: collection).and_return(true)
      subject
    end

    it "FindOrCreateImage is not called if the image is not changed" do
      params[:uploaded_image] = nil
      expect(FindOrCreateImage).not_to receive(:call)
      subject
    end
  end

  describe "url" do
    it "adds http if not given" do
      params[:url] = "www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "http://www.nowhere.nil"))
      subject
    end

    it "doesn't add another http if http is given" do
      params[:url] = "http://www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "http://www.nowhere.nil"))
      subject
    end

    it "doesn't add another http if https is given" do
      params[:url] = "https://www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "https://www.nowhere.nil"))
      subject
    end

    it "doesn't try to correct problems if http is given" do
      params[:url] = "http//www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "http//www.nowhere.nil"))
      subject
    end

    it "doesn't try to correct problems if http is given" do
      params[:url] = "https//www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "https//www.nowhere.nil"))
      subject
    end

    # It can't fix everything...
    it "does add http if http is given but misspelled" do
      params[:url] = "htp://www.nowhere.nil"
      expect(collection).to receive(:attributes=).with(include(url: "http://htp://www.nowhere.nil"))
      subject
    end
  end

  describe "collection_configuration" do
    it "calls CreateCollectionConfiguration after a success save" do
      expect(CreateCollectionConfiguration).to receive(:call)
      subject
    end

    it "does not call CreateCollectionConfiguration after a failure" do
      allow(collection).to receive(:save).and_return(false)
      expect(CreateCollectionConfiguration).to_not receive(:call)
      subject
    end
  end
end
