require "rails_helper"

describe Destroy::Showcase do
  let(:section) { instance_double(Section, destroy!: true) }
  let(:showcase) { instance_double(Showcase, sections: [section, section], destroy!: true) }
  let(:destroy_section) { instance_double(Destroy::Section, cascade!: nil) }
  let(:subject) { Destroy::Showcase.new(destroy_section: destroy_section) }

  before (:each) do
    allow_any_instance_of(SiteObjectsQuery).to receive(:exists?).and_return(false)
  end

  describe "#destroy" do
    it "destroys the Showcase" do
      expect(showcase).to receive(:destroy!)
      subject.destroy!(showcase: showcase)
    end

    it "does not destroy the Showcase if CanDelete fails" do
      expect(CanDelete).to receive(:showcase?).and_return(false)
      expect(showcase).not_to receive(:destroy!)
      subject.destroy!(showcase: showcase)
    end
  end

  describe "#cascade" do
    it "calls DestroySection on all associated sections" do
      expect(destroy_section).to receive(:cascade!).with(section: section).twice
      subject.cascade!(showcase: showcase)
    end

    it "destroys the Section" do
      expect(showcase).to receive(:destroy!)
      subject.cascade!(showcase: showcase)
    end

    it "does not destroy the Section if CanDelete fails" do
      expect(CanDelete).to receive(:showcase?).and_return(false)
      expect(showcase).not_to receive(:destroy!)
      subject.cascade!(showcase: showcase)
    end

    it "returns nil if CanDelete fails" do
      expect(CanDelete).to receive(:showcase?).and_return(false)
      expect(subject.cascade!(showcase: showcase)).to be(nil)
    end

    it "can force destroy the showcase" do
      expect(showcase).to receive(:destroy!)
      subject.force_cascade!(showcase: showcase)
    end
  end

  context "cascade transaction" do
    let(:destroy_section) { Destroy::Section.new }
    let(:subject) { Destroy::Showcase.new(destroy_section: destroy_section) }
    let(:showcase) { FactoryGirl.create(:showcase) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:sections) { [FactoryGirl.create(:section, id: 1, showcase_id: showcase.unique_id, showcase: showcase), FactoryGirl.create(:section, id: 2, showcase_id: showcase.unique_id, showcase: showcase)] }

    before(:each) do
      collection
      sections
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      sections.each do |section|
        expect { section.reload }.not_to raise_error
      end
      expect { showcase.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::Section" do
      # Throw error on second object to allow first one to get deleted
      allow(showcase).to receive(:sections).and_return(sections)
      allow(sections[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(showcase: showcase) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Showcase.destroy!" do
      allow(showcase).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(showcase: showcase) }.to raise_error("error")
      data_still_exists!
    end
  end
end
