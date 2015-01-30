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

  describe 'mock image_decorator' do
    let(:image_decorator) { instance_double(ItemImageDecorator) }

    before do
      allow(subject).to receive(:image_decorator).and_return(image_decorator)
    end

    describe '#image_title' do
      it 'calls image_decorator#title' do
        expect(image_decorator).to receive(:title).and_return('title')
        expect(subject.image_title()).to eq('title')
      end
    end

    describe '#thumbnail' do
      it 'calls image_decorator#render with default options' do
        expect(image_decorator).to receive(:render).with(:small, {}).and_return('thumbnail')
        expect(subject.thumbnail()).to eq('thumbnail')
      end

      it 'calls image_decorator#render with the specified options' do
        expect(image_decorator).to receive(:render).with(:style, {test: :test}).and_return('thumbnail')
        expect(subject.thumbnail(:style, {test: :test})).to eq('thumbnail')
      end
    end

    describe '#render_image_zoom' do
      it 'calls image_decorator#render_image_zoom with default options' do
        expect(image_decorator).to receive(:render_image_zoom).with({}).and_return('zoom')
        expect(subject.render_image_zoom()).to eq('zoom')
      end

      it 'calls image_decorator#render_image_zoom with the specified options' do
        expect(image_decorator).to receive(:render_image_zoom).with({test: :test}).and_return('zoom')
        expect(subject.render_image_zoom({test: :test})).to eq('zoom')
      end
    end
  end

  describe '#image_decorator' do
    let(:honeypot_image) { instance_double(HoneypotImage) }
    it 'returns a ItemImageDecorator' do
      expect(item).to receive(:honeypot_image).and_return(honeypot_image)
      expect(ItemImageDecorator).to receive(:new).with(honeypot_image).and_return('decorated')
      expect(subject.send(:image_decorator)).to eq('decorated')
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

  it 'returns the edit path' do
    expect(subject.edit_path).to eq('/collections/2/items/1/edit')
  end

  it 'returns the show path' do
    expect(subject.show_path).to eq('/collections/2/items/1')
  end
end
