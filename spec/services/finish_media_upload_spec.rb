require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe FinishMediaUpload do
  let(:media) { instance_double(Video, id: 1, save: true, "serializer=" => true, "status=" => 1, uuid: "uuid", file_name: "file name", type: "Video", "json_response=" => true) }
  let(:subject) { FinishMediaUpload.call(media: media) }

  let(:s3) { double(bucket: bucket) }
  let(:bucket) { double(object: bucket_object) }
  let(:bucket_object) { double(presigned_url: "presigned url", public_url: "public url") }

  before(:each) do
    allow_any_instance_of(AllocateS3Url).to receive(:s3).and_return(s3)
  end

  it "sets the status to ready" do
    expect(media).to receive("status=").with(:ready)
    subject
  end

  it "saves the media" do
    expect(media).to receive(:save).and_return(true)
    subject
  end

  it "sets the serializer" do
    expect(media).to receive("serializer=").with(SerializeMedia)
    subject
  end

  it "uses BuzzMedia to create the media on the buzz server" do
    expect(BuzzMedia).to receive(:call_create)
    subject
  end

  it "uses BuzzMedia to create the media on the buzz server" do
    allow(BuzzMedia).to receive(:call_create).and_return(false)
    expect(media).not_to receive("status=").with(:ready)
    subject
  end

  it "returns the media object" do
    expect(subject).to eq(media)
  end
end
