require "rails_helper"

RSpec.describe SaveExhibit, type: :model do
  subject { described_class.call(exhibit, params) }
  let(:exhibit) { Exhibit.new }
  let(:params) { { name: "name" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(exhibit).to receive(:save).and_return(true)
  end

  it "returns when the save is successful" do
    expect(exhibit).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the save is not successful" do
    expect(exhibit).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes to the new values " do
    expect(exhibit).to receive(:attributes=).with(params)
    subject
  end

  # describe "image processing" do
  #   it "Queues image processing if the image was updated" do
  #     params[:uploaded_image] = upload_image
  #     expect(exhibit).to receive(:save).and_return(true)
  #     expect(QueueJob).to receive(:call).with(ProcessImageJob, object: exhibit).and_return(true)
  #     subject
  #   end
  #
  #   it "is not called if the image is not changed" do
  #     params[:uploaded_image] = nil
  #     expect(exhibit).to receive(:save).and_return(true)
  #     expect(QueueJob).to_not receive(:call)
  #     subject
  #   end
  # end
end
