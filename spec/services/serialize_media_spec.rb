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
    let(:subject) { SerializeMedia.to_hash(media: media) }

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
      allow(media).to receive(:json_response).and_return({ "@id" => "media server @id" })
      expect(subject).to include("@id" => media.uuid)
      expect(subject).not_to include("@id" => "media server @id")
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
    let(:subject) { JSON.parse(SerializeMedia.to_json(media: media), symbolize_names: true) }

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
      allow(media).to receive(:json_response).and_return({ "@id" => "media server @id" })
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
end
