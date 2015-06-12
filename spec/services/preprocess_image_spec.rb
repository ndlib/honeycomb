require "rails_helper"

RSpec.describe PreprocessImage do
  let(:object) { instance_double(Item) }
  let(:uploaded_image) { double(Paperclip::Attachment, instance: object) }

  let(:instance) { described_class.new(uploaded_image) }

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "instantiates a new instance and calls #process" do
        expect(subject).to receive(:new).with(uploaded_image).and_call_original
        expect_any_instance_of(described_class).to receive(:process)
        subject.call(uploaded_image)
      end
    end
  end
end
