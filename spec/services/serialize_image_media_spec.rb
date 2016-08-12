require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe SerializeImageMedia do
  let(:paperclip_attachment) do
    instance_double(Paperclip::Attachment,
                    content_type: "image/jpeg",
                    original_filename: "filename",
                    name: "filename",
                    url: "image_uri",
                    width: 200,
                    height: 100)
  end
  let(:media) do
    instance_double(Image,
          status: "ready",
          image: paperclip_attachment,
          json_response: { "thumbnail/large" => { "contentUrl" => "image_uri" }, "contentUrl" => "base_url" })
  end

  describe "to_hash" do
    let(:subject) { described_class.to_hash(media: media) }

    it "includes the @id" do
      expect(subject).to include("@id" => "image_uri")
    end

    it "includes the name" do
      expect(subject).to include("name" => media.image.original_filename)
    end

    it "includes the type" do
      expect(subject).to include("@type" => "ImageObject")
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end

    #["unprocessed", "processing"].each do |state|
    #  it "renders a status of 'not ready' for the '#{state}' state" do
    #    allow(media).to receive(:status).and_return(state)
    #    expect(subject).to include("status" => "not ready")
    #  end
    #end

    #["ready"].each do |state|
    #  it "renders a status of 'ready' for the '#{state}' state" do
    #    allow(media).to receive(:status).and_return(state)
    #    expect(subject).to include("status" => "ready")
    #  end
    #end

    #["unavailable"].each do |state|
    #  it "renders a status of 'error' for the '#{state}' state" do
    #    allow(media).to receive(:status).and_return(state)
    #    expect(subject).to include("status" => "error")
    #  end
    #end
  end

  describe "to_json" do
    let(:subject) { JSON.parse(described_class.to_json(media: media)) }

    it "includes the @id" do
      expect(subject).to include("@id" => "image_uri")
    end

    it "includes the name" do
      expect(subject).to include("name" => media.image.original_filename)
    end

    it "includes the type" do
      expect(subject).to include("@type" => "ImageObject")
    end

    it "includes the json response" do
      expect(subject).to include(media.json_response)
    end
  end
end
