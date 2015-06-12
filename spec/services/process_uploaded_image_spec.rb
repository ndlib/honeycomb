require "rails_helper"

RSpec.describe ProcessUploadedImage do
  let(:object) { instance_double(Item, uploaded_image: uploaded_image) }
  let(:uploaded_image) { double(Paperclip::Attachment) }
  let(:path) { "/tmp/test" }
  let(:instance) { described_class.new(object: object) }

  subject { instance }

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

  describe "#process" do
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

  describe "#process_uploaded_image" do
    before do
      allow(PreprocessImage).to receive(:call).and_return(path)
      allow(subject).to receive(:copy_processed_image)
      allow(subject).to receive(:save_object)
      allow(subject).to receive(:delete_processed_image)
    end

    it "calls PreprocessImage" do
      expect(PreprocessImage).to receive(:call).with(uploaded_image).and_return(path)
      subject.send(:process_uploaded_image)
    end

    it "calls #copy_processed_image" do
      expect(subject).to receive(:copy_processed_image).with(path)
      subject.send(:process_uploaded_image)
    end

    it "returns the result of save_object" do
      expect(subject).to receive(:save_object).and_return(object)
      expect(subject.send(:process_uploaded_image)).to eq(object)
    end

    it "calls delete_processed_image" do
      expect(subject).to receive(:delete_processed_image).with(path)
      subject.send(:process_uploaded_image)
    end
  end

  describe "#uploaded_image_exists?" do
    it "returns the result of uploaded_image#exists?" do
      expect(uploaded_image).to receive(:exists?).and_return(true)
      expect(subject.send(:uploaded_image_exists?)).to eq(true)
    end
  end

  describe "#save_object" do
    it "returns the object if save is successful" do
      expect(object).to receive(:save).and_return(true)
      expect(subject.send(:save_object)).to eq(object)
    end

    it "returns false if save is not successful" do
      expect(object).to receive(:save).and_return(false)
      expect(subject.send(:save_object)).to eq(false)
    end
  end

  describe "#copy_processed_image" do
    let(:file) { instance_double(File, close: true) }

    before do
      allow(File).to receive(:open).with(path).and_return(file)
    end

    it "sets the image field and unsets the upload field" do
      expect(object).to receive("#{subject.image_field}=").with(file)
      expect(object).to receive("#{subject.upload_field}=").with(nil)
      subject.send(:copy_processed_image, path)
    end
  end

  describe "#delete_processed_image" do
    it "deletes the file if it exists" do
      expect(File).to receive(:exists?).with(path).and_return(true)
      expect(File).to receive(:delete).with(path)
      subject.send(:delete_processed_image, path)
    end

    it "does nothing if the file doesn't exist" do
      expect(File).to receive(:exists?).with(path).and_return(false)
      expect(File).to_not receive(:delete)
      subject.send(:delete_processed_image, path)
    end
  end
end
