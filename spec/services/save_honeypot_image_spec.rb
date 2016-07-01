require "rails_helper"

RSpec.describe SaveHoneypotImage do
  subject { described_class.new(image: image) }

  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/honeypot_response.json"))) }

  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [200, { content_type: "application/json" }, honeypot_json] }
      end
    end
  end

  let(:failed_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [500, { content_type: "application/json" }, "failed"] }
      end
    end
  end

  let(:items) do
    [
      instance_double(Item, id: 1),
      instance_double(Item, id: 2),
      instance_double(Item, id: 3),
    ]
  end

  let(:image) do
    instance_double(Image,
                    id: 10, collection: collection,
                    image: image_file,
                    "status=" => true,
                    "json_response=" => true,
                    save: true,
                    items: items)
  end
  let(:collection) { double(Collection, id: 100, image: image_file, save: true) }
  let(:image_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
  let(:faraday_response) { double(success?: true, body: honeypot_json) }

  before(:each) do
    allow(Index::Item).to receive(:index!).and_return(true)
  end

  describe "successful request" do
    before(:each) do
      allow(Index::Item).to receive(:index!).and_return(true)
      expect_any_instance_of(described_class).to receive(:connection).and_return(connection)
    end

    it "sends a request to the json api" do
      expect(connection).to receive(:post).with("/api/images",
                                                application_id: "honeycomb",
                                                group_id: 100,
                                                item_id: 10,
                                                image: kind_of(Faraday::UploadIO)).
        and_return(faraday_response)

      subject.save!
    end

    describe "result of #save!" do
      let(:service) { described_class.new(image: image) }
      subject { service.save! }

      it "returns the image when the request is successful" do
        expect(subject).to eq(image)
      end

      it "returns false when the image does not save" do
        expect(image).to receive(:save).and_return(false)
        expect(subject).to be(false)
      end

      it "sets the status if the object has one" do
        expect(image).to receive(:status=).with("ready")
        subject
      end

      it "reindexes the associated Items" do
        expect(Index::Item).to receive(:index!).with(items[0])
        expect(Index::Item).to receive(:index!).with(items[1])
        expect(Index::Item).to receive(:index!).with(items[2])
        subject
      end
    end
  end

  describe "failed request" do
    it "returns false when the request fails" do
      expect_any_instance_of(described_class).to receive(:connection).and_return(failed_connection)
      expect(subject.save!).to eq(false)
    end
  end

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "calls save! on a new instance" do
        expect(subject).to receive(:new).with(image: image).and_call_original
        expect_any_instance_of(described_class).to receive(:save!).and_return("saved!")
        expect(subject.call(image: image)).to eq("saved!")
      end
    end
  end

  describe "#connection" do
    it "is a Faraday connection" do
      connection = subject.send(:connection)
      expect(connection).to be_kind_of(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3019/")
    end
  end

  describe "#api_url" do
    it "returns a url to the honeypot application" do
      expect(subject.send(:api_url)).to eq("http://localhost:3019")
    end
  end

  it "uses the collection id as the group id" do
    allow_any_instance_of(described_class).to receive(:connection).and_return(connection)
    subject = described_class.new(image: image)
    expect(connection).to receive(:post).with("/api/images", hash_including(group_id: collection.id)).and_return(faraday_response)
    subject.save!
  end
end
