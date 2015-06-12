require "rails_helper"

RSpec.describe PreprocessImage do
  let(:object) { instance_double(Item) }
  let(:uploaded_image) { double(Paperclip::Attachment, instance: object, content_type: "image/jpeg") }
  let(:new_image) { instance_double(Paperclip::Attachment) }
  let(:instance) { described_class.new(uploaded_image) }

  subject { instance }

  before do
    allow(instance).to receive(:processor_attachment).and_return(new_image)
  end

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

  describe "#process" do
    let(:path) { "/tmp/test" }

    before do
      allow(subject).to receive(:attachment_path).and_return(path)
    end

    it "calls #preprocess_attachment and returns the path" do
      expect(subject).to receive(:preprocess_attachment)
      allow(subject).to receive(:processing_needed?).and_return(true)
      expect(subject.process).to eq(path)
    end

    it "returns the path" do
      expect(subject).to_not receive(:preprocess_attachment)
      allow(subject).to receive(:processing_needed?).and_return(false)
      expect(subject.process).to eq(path)
    end
  end

  describe "#preprocess_attachment" do
    it "calls reprocess on the new image" do
      expect(new_image).to receive(:reprocess!)
      subject.preprocess_attachment
    end
  end

  describe "#uploaded_image" do
    it "is the paperclip attachment" do
      expect(subject.uploaded_image).to eq(uploaded_image)
    end
  end

  describe "#processing_needed?" do
    before do
      allow(uploaded_image).to receive(:exists?).and_return(true)
      allow(subject).to receive(:tiff?).and_return(false)
      allow(subject).to receive(:exceeds_max_pixels?).and_return(false)
    end

    it "is false if the image doesn't exist" do
      expect(uploaded_image).to receive(:exists?).and_return(false)
      expect(subject.processing_needed?).to eq(false)
    end

    it "is false if the image exists and other processing isn't needed" do
      expect(uploaded_image).to receive(:exists?).and_return(true)
      expect(subject.processing_needed?).to eq(false)
    end

    it "is true if the image is a tiff" do
      expect(subject).to receive(:tiff?).and_return(true)
      expect(subject.processing_needed?).to eq(true)
    end

    it "is true if the image is exceeds the max pixels" do
      expect(subject).to receive(:exceeds_max_pixels?).and_return(true)
      expect(subject.processing_needed?).to eq(true)
    end
  end

  describe "#tiff?" do
    it "is true if the image is a tiff" do
      expect(uploaded_image).to receive(:content_type).and_return("image/tiff")
      expect(subject.tiff?).to eq(true)
    end

    it "is false otherwise" do
      expect(uploaded_image).to receive(:content_type).and_return("image/jpeg")
      expect(subject.tiff?).to eq(false)
    end
  end
end
