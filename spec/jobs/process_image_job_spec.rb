require "rails_helper"

RSpec.describe ProcessImageJob, type: :job do
  let(:object) { instance_double(Item) }

  subject { described_class }

  describe "#perform" do
    before do
      allow(QueueJob).to receive(:call)
    end

    it "calls ProcessUploadedImage with default values" do
      expect(ProcessUploadedImage).to receive(:call).with(
        object: object,
        upload_field: "uploaded_image",
        image_field: "image"
      )
      subject.perform_now(object: object)
    end

    it "calls ProcessUploadedImage with set values" do
      expect(ProcessUploadedImage).to receive(:call).with(
        object: object,
        upload_field: "other_uploaded_image",
        image_field: "other_image"
      )
      subject.perform_now(object: object, upload_field: "other_uploaded_image", image_field: "other_image")
    end

    it "Queues SaveHoneypotImageJob after processing the uploaded image" do
      expect(ProcessUploadedImage).to receive(:call)
      expect(QueueJob).to receive(:call).with(SaveHoneypotImageJob, object: object, image_field: "image")
      subject.perform_now(object: object)
    end
  end
end
