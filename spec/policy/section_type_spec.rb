require 'rails_helper'

describe SectionType do
  let(:section) { double(Section) }
  subject { described_class.new(section) }

  describe "#type" do
    it "returns type of image when there is an attached item" do
      section.stub(:item_id).and_return(1)
      expect(subject.type).to eq("image")
    end

    it "returns type of text when there is an attached item" do
      section.stub(:item_id).and_return(nil)
      expect(subject.type).to eq("text")
    end
  end


end
