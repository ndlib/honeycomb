require "rails_helper"

describe AllocateS3Url do
  subject { described_class.call(uid, filename) }
  let(:uid) { "abcdefg" }
  let(:filename) { "filename.jpg" }

  # mocks for aws api
  let(:s3) { double(bucket: bucket) }
  let(:bucket) { double(object: bucket_object) }
  let(:bucket_object) { double(presigned_url: url) }
  let(:url) { "url" }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:s3).and_return(s3)
  end

  it "generates a url from the s3 bucket" do
    expect(bucket_object).to receive(:presigned_url).and_return(url)
    subject
  end

  it "returns the url from the s3 bucket" do
    expect(subject).to eq(url)
  end

  it "passes a new filename based on the uid and the filename" do
    expect(bucket).to receive(:object).with("abcdefg.jpg").and_return(bucket_object)
    subject
  end

  it "tells s3 which bucket to use" do
    allow_any_instance_of(described_class).to receive(:bucket_name).and_return("buckety")
    expect(s3).to receive(:bucket).with("buckety").and_return(bucket)
    subject
  end

  it "sets the time limit to 1 hour" do
    expect(bucket_object).to receive(:presigned_url).with(:put, expires_in: 3600)
    subject
  end
end
