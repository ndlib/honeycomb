require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe SerializeNewS3Media do
  let(:media) do
    double(Media,
           uuid: "uuid",
           file_name: "filename.ext",
           type: "Type",
           status: "allocated",
           json_response: { response_key: "response value" },
           errors: { error_key: "error value" })
  end

  before(:each) do
    allow(AllocateS3Url).to receive(:call).and_return("upload url")
  end

  describe "to_hash" do
    let(:subject) { SerializeNewS3Media.to_hash(media: media) }

    it "uses SerializeMedia" do
      expect(SerializeMedia).to receive(:to_hash).with(media: media).and_return({})
      subject
    end

    it "uses AllocateS3Url to create the upload_url" do
      allow(AllocateS3Url).to receive(:call).and_return("upload url")
      expect(subject).to include(upload_url: "upload url")
    end
  end

  describe "to_json" do
    let(:subject) { JSON.parse(SerializeNewS3Media.to_json(media: media), symbolize_names: true) }

    it "uses SerializeMedia" do
      expect(SerializeMedia).to receive(:to_hash).with(media: media).and_return({})
      subject
    end

    it "uses AllocateS3Url to create the upload_url" do
      allow(AllocateS3Url).to receive(:call).and_return("upload url")
      expect(subject).to include(upload_url: "upload url")
    end
  end
end
