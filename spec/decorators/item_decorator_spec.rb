require 'rails_helper'

RSpec.describe ItemDecorator do
  let(:item) { instance_double(Item, title: "title", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection_id: collection.id, collection: collection, image: 'image.jpg')}
  let(:collection) { instance_double(Collection, id: 2, title: 'title')}

  subject { described_class.new(item) }

  [:id, :title, :description].each do |field|
    it "delegates #{field}" do
      expect(subject.send(field)).to eq(item.send(field))
    end
  end

  describe '#recent_children' do
    it "returns a decorated collection" do
      children = ["item"]
      expect(subject).to receive(:children_query_recent).and_return(children)
      expect(ItemsDecorator).to receive(:new).with(children).and_call_original
      expect(subject.recent_children).to be_a_kind_of(ItemsDecorator)
    end
  end

  describe '#recent_children_objects' do
    it 'queries items' do
      expect_any_instance_of(ItemQuery).to receive(:recent).and_return([])
      expect(item).to receive(:children).and_return(Item.all)
      expect(subject.recent_children).to eq([])
    end
  end

  describe 'image_tag' do
    it 'generates an image tag' do
      expect(subject.image_tag('100')).to eq("<img alt=\"Image\" src=\"/images/image.jpg\" width=\"100\" />")
    end
  end

  context 'parent item' do
    before do
      allow(item).to receive(:parent_id).and_return(nil)
    end

    it "returns true for is_parent?" do
      expect(subject.is_parent?).to be_truthy
    end

    describe '#back_path' do
      it "is the collection items index" do
        expect(subject.back_path).to eq("/collections/#{collection.id}/items")
      end
    end
  end

  context 'page_title' do
    it "renders the item_title partial" do
      expect(subject.h).to receive(:render).with({partial: '/items/item_title',  :locals=>{:item=>subject} } )
      subject.page_title
    end
  end

  context 'child item' do
    let(:child_item) { instance_double(Item, title: "Child Item", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 2, collection_id: collection.id, collection: collection, image: 'image.jpg', parent_id: 1)}
    subject { described_class.new(child_item) }

    it "returns false for is_parent?" do
      expect(subject.is_parent?).to be_falsey
    end

    describe '#back_path' do
      it "is the parent show route" do
        expect(subject.back_path).to eq("/collections/#{collection.id}/items/#{child_item.parent_id}/children")
      end
    end
  end
end
