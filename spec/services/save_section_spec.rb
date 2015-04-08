require 'rails_helper'

describe SaveSection do
  subject { described_class.call(section, params) }

  let(:section) { double(Section, id: '1', title: 'title', "attributes=" => true, save: true, "order=" => true, order: 1, "order=" => true, showcase: showcase) }
  let(:params) { { title: 'title', item_id: 1, order: 1, image: 'image', order: 1 } }
  let(:showcase) { double(Showcase, id: 1, sections: double(order: true) )}

  before(:each) do
    allow(ReorderSections).to receive(:call).and_return(true)
    allow(CreateUniqueId).to receive(:call).and_return(true)
  end

  context "successful save" do
    before(:each) do
      expect(section).to receive(:save).and_return(true)
    end

    it "checks that the sections are ordered correctly" do
      expect(ReorderSections).to receive(:call).and_return(true)
      subject
    end

    it "sets the attributes" do
      expect(section).to receive("attributes=").with(params)
      subject
    end

    it "returns the section when it is successful" do
      expect(subject).to be(section)
    end
  end

  context "unsuccessful save" do
    before(:each) do
      expect(section).to receive(:save).and_return(false)
    end

    it "returns the false when it is unsuccessful" do

      expect(subject).to be(false)
    end
  end

  describe "unique_id" do

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(section)
      subject
    end

    it "does not call create unique_id if the section does not save" do
      allow(section).to receive(:save).and_return(false)
      expect(CreateUniqueId).to_not receive(:call).with(section)
      subject
    end
  end
end
