require "rails_helper"

RSpec.describe PreprocessImage do
  let(:object) { instance_double(Item) }
  let(:uploaded_image) { double(Paperclip::Attachment, instance: object, content_type: "image/jpeg", path: "/tmp/test") }
  let(:new_image) { instance_double(Paperclip::Attachment) }

  subject { described_class.new(uploaded_image) }

  before do
    allow(subject).to receive(:processor_attachment).and_return(new_image)
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

  describe "#exceeds_max_pixels?" do
    it "is true if the image is too large" do
      expect(subject).to receive(:original_pixels).and_return(described_class::MAX_PIXELS + 1)
      expect(subject.exceeds_max_pixels?).to eq(true)
    end

    it "is false if the image is not too large" do
      expect(subject).to receive(:original_pixels).and_return(described_class::MAX_PIXELS)
      expect(subject.exceeds_max_pixels?).to eq(false)
    end
  end

  describe "#original_dimensions" do
    it "returns the width and height" do
      dimensions = [100, 200]
      expect(FastImage).to receive(:size).with(uploaded_image.path).and_return(dimensions)
      expect(subject.original_dimensions).to eq(dimensions)
    end
  end

  describe "#original_pixels" do
    it "returns the product of the dimensions" do
      dimensions = [100, 200]
      expect(subject).to receive(:original_dimensions).and_return(dimensions)
      expect(subject.original_pixels).to eq(dimensions[0] * dimensions[1])
    end
  end

  describe "#processor_attachment" do
    before do
      allow(subject).to receive(:processor_options).and_return(test: "test")
      allow(subject).to receive(:processor_attachment).and_call_original
    end

    it "returns a new instance of a paperclip attachment" do
      expect(Paperclip::Attachment).to receive(:new).with(:uploaded_image, object, {test: "test"})
      subject.processor_attachment
    end
  end

  describe "#processor_options" do
    let(:original_styles) { {test: "test"} }
    let(:style) { "style" }

    before do
      allow(uploaded_image).to receive(:options).and_return(styles: original_styles)
      allow(subject).to receive(:processor_style).and_return(style)
    end

    it "adds a new processed style to the original options" do
      expect(subject.processor_options).to eq(styles: original_styles.merge(processed: style))
    end
  end

  describe "#processor_style" do
    before do
      allow(subject).to receive(:tiff?).and_return(false)
    end

    it "limits the image to MAX_PIXELS" do
      expect(subject.processor_style).to eq("#{described_class::MAX_PIXELS}@")
    end

    it "converts tiffs to jpgs" do
      expect(subject).to receive(:tiff?).and_return(true)
      expect(subject.processor_style).to eq(["#{described_class::MAX_PIXELS}@", :jpg])
    end
  end

  describe "#processed_path" do
    it "returns the new attachment path" do
      expect(new_image).to receive(:path).with(:processed).and_return("newpath")
      expect(subject.processed_path).to eq("newpath")
    end
  end

  describe "#attachment_path" do
    it "returns the #processed_path if processing was needed" do
      expect(subject).to receive(:processing_needed?).and_return(true)
      expect(subject).to receive(:processed_path).and_return("newpath")
      expect(subject.attachment_path).to eq("newpath")
    end

    it "returns the original path if processing was not needed" do
      expect(subject).to receive(:processing_needed?).and_return(false)
      expect(uploaded_image).to receive(:path).and_return("originalpath")
      expect(subject.attachment_path).to eq("originalpath")
    end
  end
end
