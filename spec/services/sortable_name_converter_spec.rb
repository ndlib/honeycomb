require "spec_helper"

describe SortableNameConverter do
  let(:name) { "A Name" }
  subject { described_class.new(name) }

  describe "#original_name" do
    let(:name) { "Original Name" }
    it "is the original name" do
      expect(subject.original_name).to eq("Original Name")
    end
  end

  describe "#converted_name" do
    it "returns the raw name" do
      expect(subject).to receive(:original_name).and_return("raw_name")
      expect(subject.converted_name).to eq("raw_name")
    end

    it "removes leading and trailing whitespace" do
      expect(subject).to receive(:original_name).and_return(" raw_name ")
      expect(subject.converted_name).to eq("raw_name")
    end

    it "makes the name lowercase" do
      expect(subject).to receive(:original_name).and_return("Upper Name")
      expect(subject.converted_name).to eq("upper name")
    end

    %w(' " ` “ ‘ ’ ʻ).each do |quote|
      it "removes #{quote} quotes" do
        expect(subject).to receive(:original_name).and_return("#{quote} quote#{quote} quote")
        expect(subject.converted_name).to eq("quote quote")
      end
    end

    it "removes parenthesis" do
      expect(subject).to receive(:original_name).and_return("(Parenthesis) Name")
      expect(subject.converted_name).to eq("parenthesis name")
    end

    %w(a an the).each do |article|
      it "removes leading '#{article}'" do
        expect(subject).to receive(:original_name).and_return("#{article} article")
        expect(subject.converted_name).to eq("article")
      end
    end

    it "handles special characters" do
      expect(subject).to receive(:original_name).and_return("Émile Durkheim.")
      expect(subject.converted_name).to eq("emile durkheim.")
    end
  end

  describe "self" do
    subject { described_class }

    describe "#convert" do
      it "returns the converted_name" do
        expect(subject.convert("A Name")).to eq("name")
      end
    end
  end
end
