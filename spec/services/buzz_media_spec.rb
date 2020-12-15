require "rails_helper"

RSpec.describe BuzzMedia do
  subject { described_class.new(media: video) }
  let(:buzz_media_id) { "aaaa-bbbb-cccc" }
  let(:media_server_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/buzz_response.json"))) }
  let(:collection) { instance_double(Collection, id: 105) }

  before(:each) do
    allow(AllocateS3Url).to receive(:public_url).and_return("public url")
  end

  let(:video) do
    instance_double(Video,
                    type: "Video",
                    id: 10,
                    collection: collection,
                    json_response: { "@id" => buzz_media_id },
                    "json_response=" => true,
                    file_name: "1920x1200.jpeg",
                    thumbnail_url: "http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg",
                    "thumbnail_url=" => true,
                    data: { object: "test" },
                    save!: true,
                    uuid: "xxxx-yyyy-zzzz")
  end

  describe "create" do
    let(:media_server_connection) do
      Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.post("/v1/media_files") do |_env|
            [
              200,
              { content_type: "application/json" },
              media_server_json
            ]
          end
        end
      end
    end

    let(:unprocessable_media_connection) do
      Faraday.new do |builder|
        builder.use Buzz::RaiseFaradayException
        builder.adapter :test do |stub|
          stub.post("/v1/media_files") { |_env| [422, { content_type: "application/json" }, "failed"] }
        end
      end
    end

    let(:failed_media_connection) do
      Faraday.new do |builder|
        builder.use Buzz::RaiseFaradayException
        builder.adapter :test do |stub|
          stub.post("/v1/media_files") { |_env| [500, { content_type: "application/json" }, "failed"] }
        end
      end
    end

    describe "successful request" do
      let(:media_response) { double(success?: true, body: media_server_json) }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
      end

      it "sends a create request to the media server" do
        expect(media_server_connection).to receive(:post).with(
          "/v1/media_files",
          media_file: { file_path: "xxxx-yyyy-zzzz.jpeg", media_type: "video" }
        ).and_return(media_response)

        subject.create
      end
    end

    describe "when request fails" do
      it "throws an Buzz::UnprocessableEntity exception when Buzz returns a 422" do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(unprocessable_media_connection)
        expect { subject.create }.to raise_error(Buzz::UnprocessableEntity)
      end

      it "throws an Buzz::InternalServerError exception when Buzz returns a 422" do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(failed_media_connection)
        expect { subject.create }.to raise_error(Buzz::InternalServerError)
      end
    end
  end

  describe "update" do
    let(:media_server_connection) do
      Faraday.new do |builder|
        builder.use Buzz::RaiseFaradayException
        builder.adapter :test do |stub|
          stub.put("/v1/media_files/#{buzz_media_id}") do |_env|
            [
              200,
              { content_type: "application/json" },
              media_server_json
            ]
          end
        end
      end
    end

    let(:unprocessable_media_connection) do
      Faraday.new do |builder|
        builder.use Buzz::RaiseFaradayException
        builder.adapter :test do |stub|
          stub.put("/v1/media_files/#{buzz_media_id}") { |_env| [422, { content_type: "application/json" }, "failed"] }
        end
      end
    end

    let(:failed_media_connection) do
      Faraday.new do |builder|
        builder.use Buzz::RaiseFaradayException
        builder.adapter :test do |stub|
          stub.put("/v1/media_files/#{buzz_media_id}") { |_env| [500, { content_type: "application/json" }, "failed"] }
        end
      end
    end

    describe "successful request" do
      let(:media_response) { double(success?: true, body: media_server_json) }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(media_server_connection)
      end

      it "sends an update request to the media server" do
        expect(media_server_connection).to receive(:put).with(
          "/v1/media_files/#{buzz_media_id}",
          media_file: { thumbnail_url: "http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg" }
        ).and_return(media_response)

        subject.update
      end
    end

    describe "when request fails" do
      it "throws an Buzz::UnprocessableEntity exception when Buzz returns a 422" do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(unprocessable_media_connection)
        expect { subject.update }.to raise_error(Buzz::UnprocessableEntity)
      end

      it "throws an Buzz::InternalServerError exception when Buzz returns a 422" do
        allow_any_instance_of(described_class).to receive(:media_server_connection).and_return(failed_media_connection)
        expect { subject.update }.to raise_error(Buzz::InternalServerError)
      end
    end
  end

  describe "self" do
    subject { described_class }

    describe "#call_update" do
      it "calls update on a new instance" do
        allow(subject).to receive(:new).with(media: video).and_call_original
        allow_any_instance_of(described_class).to receive(:update).and_return("update")
        expect(subject.call_update(media: video)).to eq("update")
      end
    end

    describe "#call_create" do
      it "calls update on a new instance" do
        allow(subject).to receive(:new).with(media: video).and_call_original
        allow_any_instance_of(described_class).to receive(:create).and_return("create")
        expect(subject.call_create(media: video)).to eq("create")
      end
    end
  end
end
