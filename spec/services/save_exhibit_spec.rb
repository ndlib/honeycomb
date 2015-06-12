require "rails_helper"

RSpec.describe SaveExhibit, type: :model do
  subject { described_class.call(exhibit, params) }
  let(:exhibit) { Exhibit.new }
  let(:params) { { name: "name" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(exhibit).to receive(:save).and_return(true)
  end

  describe "image processing" do
    it "Queues image processing if the image was updated" do
      params[:uploaded_image] = upload_image
      expect(exhibit).to receive(:save).and_return(true)
      expect(QueueJob).to receive(:call).with(ProcessImageJob, object: exhibit).and_return(true)
      subject
    end

    it "is not called if the image is not changed" do
      params[:uploaded_image] = nil
      expect(exhibit).to receive(:save).and_return(true)
      expect(QueueJob).to_not receive(:call)
      subject
    end
  end
end
