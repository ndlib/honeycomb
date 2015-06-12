require "rails_helper"

RSpec.describe ProcessUploadedImage do
  let(:object) { instance_double(Item) }

  subject { described_class.new(object: object) }

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "instantiates a new instance and calls #process" do
        expect(subject).to receive(:new).with(object: object).and_call_original
        expect_any_instance_of(described_class).to receive(:process)
        subject.call(object: object)
      end
    end
  end

  describe "process" do
    it "calls #process_uploaded_image and returns the result" do
      expect(subject).to receive(:process_uploaded_image).and_return(object)
      allow(subject).to receive(:uploaded_image_exists?).and_return(true)
      expect(subject.process).to eq(object)
    end

    it "returns true when there is no uploaded image" do
      expect(subject).to_not receive(:process_uploaded_image)
      allow(subject).to receive(:uploaded_image_exists?).and_return(false)
      expect(subject.process).to eq(true)
    end
  end
end
