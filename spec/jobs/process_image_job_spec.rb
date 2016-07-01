require "rails_helper"

RSpec.describe ProcessImageJob, type: :job do
  let(:object) { instance_double(Item) }

  subject { described_class }

  describe "#perform" do
    before do
      allow(QueueJob).to receive(:call)
    end

    it "Queues SaveHoneypotImageJob after processing the uploaded image" do
      expect(QueueJob).to receive(:call).with(SaveHoneypotImageJob, object: object, image_field: "image")
      subject.perform_now(object: object)
    end
  end
end
