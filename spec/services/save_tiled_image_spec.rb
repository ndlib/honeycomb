require "rails_helper"

RSpec.describe SaveTiledImage do
  subject { described_class.call(item) }

  let(:jsonresponse) { {image: { width: 1200, height: 1600, type: "jpeg", path: "path", uri: "url" } } }

  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post('/image') { |env| [ 200, {content_type: 'application/json'}, jsonresponse ]}
      end
    end
  end

  let(:failed_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post('/image') { |env| [ 500, {content_type: 'application/json'}, "failed" ]}
      end
    end
  end

  let(:tiled_image) { TiledImage.new(item_id: 1) }
  let(:item) { double(Item, id: 1, collection: collection, image: image, tiled_image: tiled_image) }
  let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg"), content_type: 'image/jpeg') }
  let(:collection) { double(Collection, id: 1)}
  let(:faraday_response) { double( success?: true, body: jsonresponse )}

  context "successful request" do

    before(:each) do
      expect_any_instance_of(described_class).to receive(:connection).and_return(connection)
    end

    it "sends a request to the json api" do
      expect(connection).to receive(:post).with('/image', { namespace: 'honeycomb/1/1', image: kind_of(Faraday::UploadIO) }).and_return(faraday_response)

      subject
    end

    it "calls the build method if item does not have a tiled_image" do
      expect(item).to receive(:tiled_image).and_return(nil)
      expect(item).to receive(:build_tiled_image).and_return(tiled_image)

      subject
    end

    it "creates a database records when the requst is successful" do
      expect(subject).to be_kind_of(TiledImage)
    end

    it "sets a uri tiled image object" do
      expect(subject.uri).to eq("url")
    end

    it "sets a width in the tiled image object" do
      expect(subject.width).to eq(1200)
    end

    it "sets a height in the tiled image object" do
      expect(subject.height).to eq(1600)
    end

    it "returns false when the tiled_image does not save" do
      expect(tiled_image).to receive(:save).and_return(false)
      expect(subject).to be(false)
    end
  end

  context "failed request" do

    it "returns false when the request fails" do
        expect_any_instance_of(described_class).to receive(:connection).and_return(failed_connection)
        expect(subject).to eq(false)
    end
  end
end
