require "rails_helper"
require "support/item_meta_helpers"

# rubocop:disable Style/HashSyntax
RSpec.describe SerializeAVMedia do
  let(:media) do
    double(Media,
           uuid: "uuid",
           file_name: "filename.ext",
           type: "Type",
           status: "allocated",
           thumbnail_url: "thumbnail url",
           json_response: { response_key: "response value" },
           errors: { error_key: "error value" })
  end

  describe "to_hash" do
    let(:subject) { described_class.to_hash(media: media) }

    it "includes the @id" do
      expect(subject).to include("@id" => media.uuid)
    end

    it "includes the name" do
      expect(subject).to include(name: media.file_name)
    end

    it "includes the type" do
      expect(subject).to include("@type" => "TypeObject")
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end

    it "includes the errors" do
      expect(subject).to include(media.errors)
    end

    it "uses the Honeycomb uuid as @id even when json_response contains an @id" do
      allow(media).to receive(:json_response).and_return("@id" => "media server @id")
      expect(subject).to include("@id" => media.uuid)
      expect(subject).not_to include("@id" => "media server @id")
    end

    it "includes the default medium thumbnailUrl when there is none in the json response" do
      media.json_response.delete(:thumbnailUrl)
      expect(subject).to include(thumbnailUrl: "http://localhost:3017/images/medium/default-type-thumbnail.jpg")
    end

    it "includes the default medium thumbnailUrl when there is a nil one in the json response" do
      media.json_response[:thumbnailUrl] = nil
      expect(subject).to include(thumbnailUrl: "http://localhost:3017/images/medium/default-type-thumbnail.jpg")
    end

    it "includes the default medium thumbnailUrl when there is an empty string one in the json response" do
      media.json_response[:thumbnailUrl] = ""
      expect(subject).to include(thumbnailUrl: "http://localhost:3017/images/medium/default-type-thumbnail.jpg")
    end

    it "includes the given thumbnailUrl when one is present in the json response" do
      media.json_response[:thumbnailUrl] = "thumbnail url"
      expect(subject).to include(thumbnailUrl: "thumbnail url")
    end

    ["allocated"].each do |state|
      it "renders a status of 'not ready' for the '#{state}' state" do
        allow(media).to receive(:status).and_return(state)
        expect(subject).to include(status: "not ready")
      end
    end

    ["ready"].each do |state|
      it "renders a status of 'ready' for the '#{state}' state" do
        allow(media).to receive(:status).and_return(state)
        expect(subject).to include(status: "ready")
      end
    end
  end

  describe "to_json" do
    let(:subject) { JSON.parse(described_class.to_json(media: media), symbolize_names: true) }

    it "includes the @id" do
      expect(subject).to include(:"@id" => media.uuid)
    end

    it "includes the name" do
      expect(subject).to include(name: media.file_name)
    end

    it "includes the type" do
      expect(subject).to include(:"@type" => "TypeObject")
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end

    it "includes the errors" do
      expect(subject).to include(media.errors)
    end

    it "uses the Honeycomb uuid as @id even when json_response contains an @id" do
      allow(media).to receive(:json_response).and_return("@id" => "media server @id")
      expect(subject).to include(:"@id" => media.uuid)
      expect(subject).not_to include(:"@id" => "media server @id")
    end

    ["allocated"].each do |state|
      it "renders a status of 'not ready' for the '#{state}' state" do
        allow(media).to receive(:status).and_return(state)
        expect(subject).to include(status: "not ready")
      end
    end

    ["ready"].each do |state|
      it "renders a status of 'ready' for the '#{state}' state" do
        allow(media).to receive(:status).and_return(state)
        expect(subject).to include(status: "ready")
      end
    end
  end
  # rubocop:enable Style/HashSyntax
end
