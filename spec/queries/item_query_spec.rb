require "rails"

describe ItemQuery do
  subject { described_class.new(relation) }
  let(:relation) { Item.all }

  describe "#relation" do
    it "returns the relation" do
      expect(subject.relation).to eq(relation)
    end
  end

  describe "#recent" do
    it "orders by update date" do
      expect(relation).to receive(:order).with(updated_at: :desc).and_return(relation)
      subject.recent
    end

    it "limits to the amount passed in " do
      expect(relation).to receive(:limit).with(10).and_return(relation)
      subject.recent(10)
    end

    it "limits to the default amount" do
      expect(relation).to receive(:limit).with(5).and_return(relation)
      subject.recent
    end
  end

  describe "#only_top_level" do
    it "returns only the items that are parents" do
      expect(relation).to receive(:where).with(parent_id: nil).and_call_original
      subject.only_top_level
    end

    it "includes the image" do
      expect(relation).to receive(:includes).with(:media).and_call_original
      subject.only_top_level
    end
  end

  describe "find" do
    it "finds the object" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe "build" do
    it "builds a object off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end

    it "accepts default arguments" do
      item = subject.build(collection_id: 1)
      expect(item.collection_id).to eq(1)
    end
  end

  describe "published" do
    it "gets the published items" do
      # expect(relation).to receive(:where).with(published: true)
      subject.published
    end
  end

  describe "public_find" do
    it "calls public_find!" do
      expect(relation).to receive(:find_by!).with(unique_id: "asdf")
      subject.public_find("asdf")
    end

    it "raises an error on not found" do
      expect { subject.public_find("asdf") }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "can_delete?" do
    let(:relation) { instance_double(Item, pages: [], showcases: [], children: []) }
    let(:child) { instance_double(Item) }
    let(:showcase) { instance_double(Showcase) }
    let(:page) { instance_double(Page) }

    it "returns false if the item has children" do
      allow(relation).to receive(:showcases).and_return([])
      allow(relation).to receive(:children).and_return([child])
      expect(subject.can_delete?).to eq(false)
    end

    it "returns false if its used in a showcase" do
      allow(relation).to receive(:showcases).and_return([showcase])
      allow(relation).to receive(:children).and_return([])
      expect(subject.can_delete?).to eq(false)
    end

    it "returns false if its used in a page" do
      allow(relation).to receive(:pages).and_return([page])
      allow(relation).to receive(:children).and_return([])
      expect(subject.can_delete?).to eq(false)
    end
  end
end
