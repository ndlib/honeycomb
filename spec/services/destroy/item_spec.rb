require "rails_helper"

describe Destroy::Item do
  let(:section) { instance_double(Section, destroy!: true) }
  let(:page) { instance_double(Page, destroy!: true) }
  let(:showcase) { instance_double(Showcase) }
  let(:child) { instance_double(Item, pages: [], showcases: [], sections: [], children: [child2], destroy!: true) }
  let(:child2) { instance_double(Item, pages: [], showcases: [], sections: [], children: [], destroy!: true) }
  let(:item) do
    instance_double(
      Item, pages: [page, page, page], showcases: [], sections: [section, section], children: [child, child], destroy!: true, item_metadata: double(valid?: true)
    )
  end
  let(:item2) { instance_double(Item, pages: [], showcases: [], sections: [], children: [], destroy!: true, item_metadata: double(valid?: true)) }
  let(:item3) { instance_double(Item, pages: [], showcases: [], sections: [section, section], children: [child, child], destroy!: true, item_metadata: double(valid?: true)) }

  let(:destroy_section) { instance_double(Destroy::Section, cascade!: nil) }
  let(:subject) { Destroy::Item.new(destroy_section: destroy_section) }

  before do
    allow(Index::Item).to receive(:remove!)
    allow(RemovePageItem).to receive(:call)
  end

  describe "#destroy!" do
    context "when there are no page or sections associations" do
      it "destroys the Item" do
        expect(item2).to receive(:destroy!)
        subject.destroy!(item: item2)
      end

      it "removes the item from the search index" do
        expect(Index::Item).to receive(:remove!).with(item2)
        subject.destroy!(item: item2)
      end
    end

    context "when there are page associations" do
      it "does not destroy the Item" do
        expect(item).not_to receive(:destroy!)
        subject.destroy!(item: item)
      end

      it "does not remove the item from the search index" do
        expect(Index::Item).not_to receive(:remove!).with(item)
        subject.destroy!(item: item)
      end
    end

    context "when there are sections associations" do
      it "does not destroy the item" do
        expect(item3).not_to receive(:destroy!)
        subject.destroy!(item: item3)
      end

      it "does not remove the item from the search index" do
        expect(Index::Item).not_to receive(:remove!).with(item3)
        subject.destroy!(item: item3)
      end
    end
  end

  describe "#cascade!" do
    it "calls delete on all page associations" do
      expect(item.pages).to receive(:delete).with(page).at_least(3).times
      subject.cascade!(item: item)
    end

    it "calls DestroySection on all associated sections" do
      expect(destroy_section).to receive(:cascade!).with(section: section).twice
      subject.cascade!(item: item)
    end

    it "calls DestroyItem on all associated child items" do
      # Can't test for cascade call here since it's a recursive call and stubbing
      # it out will cause it to never call cascade on the child objects. Instead,
      # it tests to see that it calls destroy on the item's children, and it's
      # childrens' children, implying that cascade was properly called.
      allow(CanDelete).to receive(:item?)
      expect(CanDelete).to receive(:item?).with(child).twice
      expect(CanDelete).to receive(:item?).with(child2).twice
      subject.cascade!(item: item)
    end

    it "destroys sections before children to prevent FK constraints on Item->Section" do
      expect(destroy_section).to receive(:cascade!).with(section: section).at_least(:once).ordered
      allow(CanDelete).to receive(:item?)
      expect(CanDelete).to receive(:item?).with(child).at_least(:once)
      subject.cascade!(item: item)
    end

    it "destroys the Item" do
      expect(item2).to receive(:destroy!)
      subject.cascade!(item: item2)
    end

    it "removes the item from the search index" do
      expect(Index::Item).to receive(:remove!).with(item2)
      subject.cascade!(item: item2)
    end
  end

  context "cascade transaction" do
    let(:destroy_section) { Destroy::Section.new }
    let(:subject) { Destroy::Item.new(destroy_section: destroy_section) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:item) { FactoryGirl.create(:item) }
    let(:showcase) { FactoryGirl.create(:showcase) }
    let(:sections) do
      [FactoryGirl.create(:section, id: 1, item_id: item.id),
       FactoryGirl.create(:section, id: 2, item_id: item.id)]
    end
    let(:children) do
      [FactoryGirl.create(:item, id: 3, parent_id: item.id, user_defined_id: "three"),
       FactoryGirl.create(:item, id: 4, parent_id: item.id, user_defined_id: "four")]
    end

    before(:each) do
      allow_any_instance_of(Metadata::Fields).to receive(:valid?).and_return(true)
      collection
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
      allow(item2).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(item: item2) }.to raise_error("error")
      data_still_exists!
    end

    it "does not remove the item from the index if an error occurs" do
      expect(item2).to receive(:destroy!).and_raise(RuntimeError)
      expect(Index::Item).to_not receive(:remove!).with(item2)
      expect { subject.cascade!(item: item2) }.to raise_error(RuntimeError)
      data_still_exists!
    end
  end
end
