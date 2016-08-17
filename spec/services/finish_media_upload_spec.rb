require "rails_helper"
require "support/item_meta_helpers"

RSpec.describe FinishMediaUpload do
  let(:media) { instance_double(Video, id: 1, save: true, "serializer=" => true, "status=" => 1) }
  let(:subject) { FinishMediaUpload.call(media: media) }

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

  it "returns the media object" do
    expect(subject).to eq(media)
  end
end
