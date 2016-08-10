require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe SerializeMedia do
  let(:media) do
    double(Media,
           uuid: "uuid",
           file_name: "filename.ext",
           type: "Type",
           json_response: { response_key: "response value" },
           errors: { error_key: "error value" } )
  end

  describe "to_hash" do
    let(:subject) { SerializeMedia.to_hash(media: media) }

    it "includes the uuid" do
      expect(subject).to include(uuid: media.uuid)
    end

    it "includes the filename" do
      expect(subject).to include(file_name: media.file_name)
    end

    it "includes the type lowercase" do
      expect(subject).to include(media_type: media.type.downcase)
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end

    it "includes the errors" do
      expect(subject).to include(media.errors)
    end
  end

  describe "to_json" do
    let(:subject) { JSON.parse(SerializeMedia.to_json(media: media), symbolize_names: true) }

    it "includes the uuid" do
      expect(subject).to include(uuid: media.uuid)
    end

    it "includes the filename" do
      expect(subject).to include(file_name: media.file_name)
    end

    it "includes the type lowercase" do
      expect(subject).to include(media_type: media.type.downcase)
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end

    it "includes the errors" do
      expect(subject).to include(media.errors)
    end

    it "includes the json response" do
      expect(subject).to include(uuid: media.uuid)
    end
  end
end
