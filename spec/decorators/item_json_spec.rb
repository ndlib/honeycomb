require 'rails_helper'

RSpec.describe ItemJson do
  let(:item) { double(Item, title: "title", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection: collection, tiled_image: tiled_image)}
  let(:collection) { double(Collection, id: 2, title: 'title')}
  let(:tiled_image) { double(TiledImage, id: 3, uri: "url", width: '1000', height: '1000')}

  let(:options) { {} }
  subject { described_class.new(item).to_hash(options) }

  context "no options" do
    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to_not receive(field)
        subject
      end
    end

    [:id, :uri, :width, :height].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(tiled_image).to_not receive(field)
        subject
      end
    end
  end


  context "includes collection" do
    let(:options) { { include: 'collection' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to receive(field)
        subject
      end
    end

    [:id, :uri, :width, :height].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(tiled_image).to_not receive(field)
        subject
      end
    end
  end

  context "includes tiled_image" do
    let(:options) { { include: 'tiled_image' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to_not receive(field)
        subject
      end
    end

    [:id, :uri, :width, :height].each do | field |
      it "does not include the field, #{field}, from tiled_image " do
        expect(tiled_image).to receive(field)
        subject
      end
    end
  end


  context "includes both" do
    let(:options) { { include: 'tiled_image, collection' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to receive(field)
        subject
      end
    end

    [:id, :uri, :width, :height].each do | field |
      it "does not include the field, #{field}, from tiled_image " do
        expect(tiled_image).to receive(field)
        subject
      end
    end

  end

end
