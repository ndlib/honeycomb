require 'rails_helper'

RSpec.describe ItemJson do
  let(:item) { instance_double(Item, title: "title", description: "description", manuscript_url: "http://example.com/manuscript", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection: collection, honeypot_image: honeypot_image, parent_id: nil, child_ids: [])}
  let(:collection) { instance_double(Collection, id: 2, title: 'title')}
  let(:honeypot_image) { instance_double(HoneypotImage, image_json: {image: "image"}) }

  let(:options) { {} }
  subject { described_class.new(item) }
  let(:result_hash) { subject.to_hash(options) }

  describe '#item_data' do
    [:title, :description, :updated_at, :id, :manuscript_url].each do | field |
      it "includes the field, #{field}, from the item" do
        expect(item).to receive(field).and_return(field)
        expect(subject.send(:item_data)[field]).to eq(field)
      end
    end
  end

  describe '#parent_data' do
    it "is the item parent_id" do
      expect(item).to receive(:parent_id).and_return(5)
      expect(subject.send(:parent_data)).to eq(5)
    end
  end

  describe '#children_data' do
    it "is the item child_ids" do
      expect(item).to receive(:child_ids).and_return([6,7])
      expect(subject.send(:children_data)).to eq([6,7])
    end
  end

  describe '#collection_data' do
    [:id, :title].each do | field |
      it "includes the field, #{field}, from the collection " do
        expect(collection).to receive(field).and_return(field)
        expect(subject.send(:collection_data)[field]).to eq(field)
      end
    end
  end

  describe '#image_data' do
    it "includes the image_json from the image" do
      expect(honeypot_image).to receive(:image_json).and_return({image: "image"})
      expect(subject.send(:image_data)).to eq({image: "image"})
    end
  end

  context "no options" do
    it "includes the #item_data" do
      expect(subject).to receive(:item_data).and_return({item_data: 'item_data'})
      expect(result_hash[:item_data]).to eq('item_data')
    end

    it "includes the parent_data in the links" do
      expect(subject).to receive(:parent_data).and_return(1)
      expect(result_hash[:links][:parent]).to eq(1)
    end

    it "includes the children_data in the links" do
      expect(subject).to receive(:children_data).and_return([2,3])
      expect(result_hash[:links][:children]).to eq([2,3])
    end

    it "does not include the #collection_data" do
      expect(subject).to_not receive(:collection_data)
      expect(result_hash[:links][:collection]).to be_nil
    end

    it "does not include the #image_data" do
      expect(subject).to_not receive(:image_data)
      expect(result_hash[:links][:image]).to be_nil
    end
  end


  context "includes collection" do
    let(:options) { { include: 'collection' } }

    it "includes the #collection_data" do
      expect(subject).to receive(:collection_data).and_return({id: 1, title: 'title'})
      expect(result_hash[:links][:collection]).to eq({id: 1, title: 'title'})
    end
  end

  context "includes tiled_image" do
    let(:options) { { include: 'image' } }

    it "includes the #image_data" do
      expect(subject).to receive(:image_data).and_return({image: "image"})
      expect(result_hash[:links][:image]).to eq({image: "image"})
    end
  end


  context "includes both" do
    let(:options) { { include: 'tiled_image, collection' } }

    it "includes the #collection_data" do
      expect(subject).to receive(:collection_data).and_return({id: 1, title: 'title'})
      expect(result_hash[:links][:collection]).to eq({id: 1, title: 'title'})
    end

    it "includes the #image_data" do
      expect(subject).to receive(:image_data).and_return({image: "image"})
      expect(result_hash[:links][:image]).to eq({image: "image"})
    end

  end

end
