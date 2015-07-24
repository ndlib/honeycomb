require "rails_helper"

RSpec.describe V1::MetadataJSON do
  subject { described_class.new(item) }

  let(:item) { double(Item) }
  let(:json) { double }

  describe "generic fields" do
    [:name, :creator, :alternate_name, :publisher, :rights, :original_language, :date_created, :date_modified, :date_published].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#description" do
    let(:item) { double(Item, description: "description") }

    it "converts null to empty string" do
      allow(item).to receive(:description).and_return(nil)
      expect(subject.description).to eq("")
    end

    it "uses the item description" do
      expect(item).to receive(:description).and_return("description")
      expect(subject.description).to eq("description")
    end
  end

  describe "#transcription" do
    let(:item) { double(Item, transcription: "transcription") }

    it "converts null to empty string" do
      allow(item).to receive(:transcription).and_return(nil)
      expect(subject.transcription).to eq("")
    end

    it "uses the item transcription" do
      expect(item).to receive(:transcription).and_return("transcription")
      expect(subject.transcription).to eq("transcription")
    end
  end

  # do the dates as a loop since they are all the same
  [
    :date_created,
    :date_published,
    :date_modified,
  ].each do |field|
    describe "##{field}" do
      it "returns nil if there is no #{field}" do
        item.stub(field).and_return(nil)
        expect(subject.send(field)).to eq(nil)
      end

      it "returns nil if the field value is \"\"" do
        item.stub(field).and_return("")
        expect(subject.send(field)).to eq(nil)
      end

      it "uses the MetadataDate#display_text field" do
        item.stub(field).and_return(year: "2010", month: "10", day: "12")
        expect_any_instance_of(MetadataDate).to receive(:human_readable).and_call_original
        expect(subject.send(field)).to eq("October 12, 2010")
      end
    end
  end
end
