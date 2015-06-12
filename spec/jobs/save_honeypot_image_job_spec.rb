require "rails_helper"

RSpec.describe SaveHoneypotImageJob, type: :job do
  let(:object) { instance_double(Item) }

  subject { described_class }

  describe "#perform" do
    it "calls SaveHoneypotImage with default values" do
      expect(SaveHoneypotImage).to receive(:call).with(object: object, image_field: "image")
      subject.perform_now(object: object)
    end

    it "calls SaveHoneypotImage with set values" do
      expect(SaveHoneypotImage).to receive(:call).with(object: object, image_field: "other_image")
      subject.perform_now(object: object, image_field: "other_image")
    end
  end
end
