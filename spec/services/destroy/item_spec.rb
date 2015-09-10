require "rails_helper"

describe Destroy::Item do
  let(:section) { instance_double(Section, destroy!: true) }
  let(:child) { instance_double(Item, sections: [], children: [child2], destroy!: true) }
  let(:child2) { instance_double(Item, sections: [], children: [], destroy!: true) }
  let(:item) { instance_double(Item, sections: [section, section], children: [child, child], destroy!: true) }
  let(:destroy_section) { instance_double(Destroy::Section, cascade!: nil) }
  let(:subject) { Destroy::Item.new(destroy_section: destroy_section) }

  before do
    allow(Index::Item).to receive(:remove!)
  end

  describe "#destroy!" do
    it "destroys the Item" do
      expect(item).to receive(:destroy!)
      subject.destroy!(item: item)
    end

    it "removes the item from the search index" do
      expect(Index::Item).to receive(:remove!).with(item)
      subject.destroy!(item: item)
    end
  end

  describe "#cascade!" do
    it "calls DestroySection on all associated sections" do
      expect(destroy_section).to receive(:cascade!).with(section: section).twice
      subject.cascade!(item: item)
    end

    it "calls DestroyItem on all associated child items" do
      # Can't test for cascade call here since it's a recursive call and stubbing
      # it out will cause it to never call cascade on the child objects. Instead,
      # it tests to see that it calls destroy on the item's children, and it's
      # childrens' children, implying that cascade was properly called.
      expect(child).to receive(:destroy!).twice
      expect(child2).to receive(:destroy!).twice
      subject.cascade!(item: item)
    end

    it "destroys sections before children to prevent FK constraints on Item->Section" do
      expect(destroy_section).to receive(:cascade!).with(section: section).at_least(:once).ordered
      expect(child).to receive(:destroy!).at_least(:once).ordered
      subject.cascade!(item: item)
    end

    it "destroys the Item" do
      expect(item).to receive(:destroy!)
      subject.cascade!(item: item)
    end

    it "removes the item from the search index" do
      expect(Index::Item).to receive(:remove!).with(item)
      subject.cascade!(item: item)
    end
  end

  context "cascade transaction" do
    let(:destroy_section) { Destroy::Section.new }
    let(:subject) { Destroy::Item.new(destroy_section: destroy_section) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:item) { FactoryGirl.create(:item) }
    let(:showcase) { FactoryGirl.create(:showcase) }
    let(:exhibit) { FactoryGirl.create(:exhibit) }
    let(:sections) { [FactoryGirl.create(:section, id: 1, item_id: item.id), FactoryGirl.create(:section, id: 2, item_id: item.id)] }
    let(:children) { [FactoryGirl.create(:item, id: 3, parent_id: item.id), FactoryGirl.create(:item, id: 4, parent_id: item.id)] }

    before(:each) do
      collection
      exhibit
      showcase
      children
      sections
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      children.each do |child|
        expect { child.reload }.not_to raise_error
      end
      sections.each do |section|
        expect { section.reload }.not_to raise_error
      end
      expect { item.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::Item on child items" do
      # Throw error on second object to allow first one to get deleted
      allow(item).to receive(:children).and_return(children)
      allow(children[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(item: item) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Section" do
      # Throw error on second object to allow first one to get deleted
      allow(item).to receive(:sections).and_return(sections)
      allow(sections[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(item: item) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Item.destroy!" do
      allow(item).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(item: item) }.to raise_error("error")
      data_still_exists!
    end

    it "does not remove the item from the index if an error occurs" do
      expect(item).to receive(:destroy!).and_raise(RuntimeError)
      expect(Index::Item).to_not receive(:remove!).with(item)
      expect { subject.cascade!(item: item) }.to raise_error(RuntimeError)
      data_still_exists!
    end
  end
end
