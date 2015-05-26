require "rails_helper"

RSpec.describe ShowcaseDecorator do
  let(:showcase) { instance_double(Showcase, id: 10, name_line_1: "name_line_1", description: "description") }
  subject { described_class.new(showcase) }

  describe "#id" do
    it "is the showcase id" do
      expect(showcase).to receive(:id).and_return(100)
      expect(subject.id).to eq(100)
    end
  end

  describe "#name" do
    it "is the showcase name" do
      expect(showcase).to receive(:name_line_1).and_return("name_line_1")
      expect(subject.name_line_1).to eq("name_line_1")
    end
  end

  describe "#description" do
    it "is the showcase description" do
      expect(showcase).to receive(:description).and_return("Description")
      expect(subject.description).to eq("Description")
    end
  end

  describe "#sections" do
    it "uses the section query to retrieve the sections" do
      sections = [instance_double(Section)]
      expect(showcase).to receive(:sections).and_return(sections)
      expect(SectionQuery).to receive(:new).with(sections).and_call_original
      expect_any_instance_of(SectionQuery).to receive(:ordered).and_return(["sections"])
      expect(subject.sections).to eq(["sections"])
    end
  end
end
