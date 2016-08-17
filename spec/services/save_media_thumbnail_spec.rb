require "rails_helper"

RSpec.describe SaveMediaThumbnail do
  subject { described_class.new(image: image, item: item, media: video) }

  let(:image_server_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/honeypot_response.json"))) }
  let(:media_server_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/buzz_response.json"))) }
  let(:image) { File.new(File.join(Rails.root, "spec/fixtures/test.jpg"), "r") }

  let(:image_server_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [200, { content_type: "application/json" }, image_server_json] }
      end
    end
  end

  let(:media_server_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.put("/v1/media_files/xxxx-yyyy-zzzz") do |_env|
          [
            200,
            { content_type: "application/json" },
            media_server_json
          ]
        end
      end
    end
  end

  let(:failed_image_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [500, { content_type: "application/json" }, "failed"] }
      end
    end
  end

  let(:failed_media_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.put("/v1/media_files/xxxx-yyyy-zzzz") { |_env| [500, { content_type: "application/json" }, "failed"] }
      end
    end
  end

  let(:item) { instance_double(Item, id: 1, collection: collection) }

  let(:video) do
    instance_double(Video,
                    id: 10,
                    collection: collection,
                    "json_response=" => true,
                    data: { object: "test" },
                    save!: true,
                    uuid: "xxxx-yyyy-zzzz",
                    items: [item])
  end

  let(:collection) { double(Collection, id: 100, image: image_file, save: true) }
  let(:image_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
  let(:image_response) { double(success?: true, body: image_server_json) }
  let(:media_response) { double(success?: true, body: media_server_json) }

  describe "successful request" do
    before(:each) do
      expect_any_instance_of(described_class).to receive(:image_server_connection).and_return(image_server_connection)
      expect_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
    end

    it "sends a request to the image server" do
      expect(image_server_connection).to receive(:post).with(
        "/api/images",
        application_id: "honeycomb",
        group_id: 100,
        item_id: 1,
        image: kind_of(Faraday::UploadIO)
      ).and_return(image_response)

      subject.save!
    end

    it "sends an update request to the media server" do
      expect(media_server_connection).to receive(:put).with(
        "/v1/media_files/xxxx-yyyy-zzzz",
        application_id: "honeycomb",
        media_file: { thumbnail_url: "http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg" }
      ).
        and_return(media_response)

      subject.save!
    end
  end

  describe "#save!" do
    before(:each) do
      expect_any_instance_of(described_class).to receive(:image_server_connection).and_return(image_server_connection)
      expect_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
    end

    it "returns the image when the request is successful" do
      expect(subject.save!).to eq(media_response.body)
    end

    it "returns false when the media does not save" do
      expect(video).to receive(:save!).and_return(false)
      expect(subject.save!).to be(false)
    end
  end

  describe "when request fails" do
    it "returns false when the image request fails" do
      expect_any_instance_of(described_class).to receive(:image_server_connection).and_return(failed_image_connection)
      allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
      expect(subject.save!).to eq(false)
    end

    it "returns false when the media request fails" do
      allow_any_instance_of(described_class).to receive(:image_server_connection).and_return(image_server_connection)
      expect_any_instance_of(described_class).to receive(:media_server_connection).and_return(failed_media_connection)
      expect(subject.save!).to eq(false)
    end
  end

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "calls save! on a new instance" do
        expect(subject).to receive(:new).with(image: image, item: item, media: video).and_call_original
        expect_any_instance_of(described_class).to receive(:save!).and_return("saved!")
        expect(subject.call(image: image, item: item, media: video)).to eq("saved!")
      end
    end
  end

  describe "#image_server_connection" do
    it "is a Faraday connection" do
      connection = subject.send(:image_server_connection)
      expect(connection).to be_kind_of(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3019/")
    end
  end

  describe "#media_server_connection" do
    it "is a Faraday connection" do
      connection = subject.send(:media_server_connection)
      expect(connection).to be_kind_of(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3023/")
    end
  end

  describe "#image_server_url" do
    it "uses the collection id as the group id" do
      allow_any_instance_of(described_class).to receive(:image_server_connection).and_return(image_server_connection)
      allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
      subject = described_class.new(image: image, item: item, media: video)
      expect(image_server_connection).to receive(:post).with(
        "/api/images",
        hash_including(group_id: collection.id)
      ).and_return(image_response)
      subject.save!
    end
  end

  describe "#media_server_url" do
    it "presents correct media_file data as put param" do
      allow_any_instance_of(described_class).to receive(:image_server_connection).and_return(image_server_connection)
      allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
      subject = described_class.new(image: image, item: item, media: video)
      expect(media_server_connection).to receive(:put).with(
        "/v1/media_files/xxxx-yyyy-zzzz",
        hash_including(media_file: { thumbnail_url: "http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg" })
      ).and_return(media_response)
      subject.save!
    end
  end
end
