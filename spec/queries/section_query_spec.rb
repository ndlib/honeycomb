require 'rails_helper'

RSpec.describe SectionQuery do
  subject { described_class.new(relation)}

  let(:sections) { double( order: true )}
  let(:showcase) { double(Showcase, sections: relation) }
  let(:relation) { Section.all }
  let(:next_section) { double(Section, id: '2', order: 1, showcase_id: '2') }

  describe "#all_for_showcase" do

    it "orders all the showases" do
      expect(relation).to receive(:order).with(:order).and_return(relation)
      subject.all_in_showcase
    end

  end


  describe "find" do

    it "finds the collection" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end


  describe "build" do

    it "builds a collection off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end
  end


  describe "next" do

    it "selects for section id" do
      expect(relation).to receive(:where).with(showcase_id: next_section.id).and_return(Section.all)
      subject.next(next_section)
    end

    it "filters on order" do
      #expect(relation).to receive(:where).with("`sections`.order > ?", 1).and_return(Section.all)
      #subject.next(next_section)
    end
  end
end
