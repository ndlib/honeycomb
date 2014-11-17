require 'rails_helper'

RSpec.describe ItemDecorator do
  let(:item) { double(Item, title: "title", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection: collection, tiled_image: tiled_image, image: 'image.jpg')}
  let(:collection) { double(Collection, id: 2, title: 'title')}
  let(:tiled_image) { double(TiledImage, id: 3, host: "localhost", path: "path", width: '1000', height: '1000')}

  subject { described_class.new(item) }

  [:id, :title, :description].each do |field|
    it "delegates #{field}" do
      expect(subject.send(field)).to eq(item.send(field))
    end
  end

  describe '#recent_children' do 
    it 'queries items' do
      expect(item).to receive(:children).and_return(Item)
      expect(subject.recent_children).to eq([])
    end
  end

  describe 'image_tag' do
    it 'generates an image tag' do
      expect(subject.image_tag('100')).to eq("<img alt=\"Image\" src=\"/images/image.jpg\" width=\"100\" />")
    end
  end
end
