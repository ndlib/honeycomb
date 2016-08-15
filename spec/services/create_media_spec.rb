require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe CreateMedia do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:params) { { media_type: "" } }
  let(:subject) { CreateMedia.call(owner: owner, collection: collection, params: params) }
  let(:owner) { double(Object, "media_id=" => true, save: true) }

  context "with video" do
    let(:params) { { media_type: "video" } }
    let(:video) { instance_double(Video, "status=" => true, "uuid=" => true, id: 10, "collection=" => true, save: true, "serializer=" => true) }

    before(:each) do
      allow(Video).to receive(:new).and_return(video)
    end

    it "associates the item" do
      expect(owner).to receive(:media_id=).with(video.id)
      subject
    end

    it "sets the collection" do
      expect(video).to receive(:collection=).with(collection)
      subject
    end

    it "returns the new video" do
      expect(subject).to eq(video)
    end

    it "injects the S3 serializer" do
      expect(video).to receive(:serializer=).with(SerializeNewS3Media)
      subject
    end
  end

  context "with audio" do
    let(:params) { { media_type: "audio" } }
    let(:audio) { instance_double(Audio, "status=" => true, "uuid=" => true, id: 10, "collection=" => true, save: true, "serializer=" => true) }

    before(:each) do
      allow(Audio).to receive(:new).and_return(audio)
    end

    it "associates the item" do
      expect(owner).to receive(:media_id=).with(audio.id)
      subject
    end

    it "sets the collection" do
      expect(audio).to receive(:collection=).with(collection)
      subject
    end

    it "returns the new video" do
      expect(subject).to eq(audio)
    end

    it "injects the S3 serializer" do
      expect(audio).to receive(:serializer=).with(SerializeNewS3Media)
      subject
    end
  end

  context "with unknown types" do
    let(:params) { { media_type: "Foo" } }
    let(:media) { instance_double(Media, "uuid=" => true, id: 10, "collection=" => true, save: true, "serializer=" => true) }

    before(:each) do
      allow(Media).to receive(:new).and_return(media)
    end

    it "returns the new media" do
      expect(subject).to eq(media)
    end

    it "injects the generic serializer" do
      expect(media).to receive(:serializer=).with(SerializeMedia)
      subject
    end
  end
end
