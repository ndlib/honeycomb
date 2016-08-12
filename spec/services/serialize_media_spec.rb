require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe SerializeMedia do
  let(:media) do
    double(Media,
           uuid: "uuid",
           file_name: "filename.ext",
           type: "Type",
           status: "allocated",
           json_response: { response_key: "response value" },
           errors: { error_key: "error value" })
  end

  describe "to_hash" do
    let(:subject) { described_class.to_hash(media: media) }

    it "delegates to SerializeAVMedia when the type is Audio|Video" do
      allow(media).to receive(:type).and_return("Audio")
      allow(SerializeAVMedia).to receive(:to_hash).with(media: media).and_return("SerializeAVMedia#to_hash result")
      expect(subject).to eq("SerializeAVMedia#to_hash result")
    end

    it "delegates to SerializeImageMedia when the type is Image" do
      allow(media).to receive(:type).and_return("Image")
      allow(SerializeImageMedia).to receive(:to_hash).and_return("SerializeImageMedia#to_hash result")
      expect(subject).to eq("SerializeImageMedia#to_hash result")
    end
  end

  describe "to_json" do
    let(:subject) { described_class.to_json(media: media) }

    it "delegates to SerializeAVMedia when the type is Audio|Video" do
      allow(media).to receive(:type).and_return("Audio")
      allow(SerializeAVMedia).to receive(:to_hash).with(media: media).and_return("SerializeAVMedia#to_hash result")
      expect(subject).to eq("\"SerializeAVMedia#to_hash result\"")
    end

    it "delegates to SerializeImageMedia when the type is Image" do
      allow(media).to receive(:type).and_return("Image")
      allow(SerializeImageMedia).to receive(:to_hash).and_return("SerializeImageMedia#to_hash result")
      expect(subject).to eq("\"SerializeImageMedia#to_hash result\"")
    end
  end
end
