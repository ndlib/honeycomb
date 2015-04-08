require 'rails_helper'

RSpec.describe CollectionImage do
  subject { described_class.new(collection) }

  let(:collection) { instance_double(Collection, id: 2) }

  let(:item_with_image) { double(Item, honeypot_image: honeypot_image) }
  let(:item_with_no_image) { double(Item, honeypot_image: nil) }

  let(:honeypot_image) { double(HoneypotImage, url: 'http://image.image.com/image', image_json: { contentUrl: 'http://example.com/image.jpg' }) }

  it 'uses the item decorator to call the image display' do
    allow(collection).to receive(:items).and_return([item_with_image])

    expect_any_instance_of(HoneypotThumbnail).to receive(:display)
    subject.display
  end

  it 'dislpays the first image found' do
    allow(collection).to receive(:items).and_return([item_with_image])

    expect(subject.display).to eq("<div data-react-class=\"Thumbnail\" data-react-props=\"{&quot;image&quot;:{&quot;contentUrl&quot;:&quot;http://example.com/image.jpg&quot;}}\"></div>")
  end

  it 'displays the second image if the first item does not have an image' do
    allow(collection).to receive(:items).and_return([item_with_no_image, item_with_image])

    expect(subject.display).to eq("<div data-react-class=\"Thumbnail\" data-react-props=\"{&quot;image&quot;:{&quot;contentUrl&quot;:&quot;http://example.com/image.jpg&quot;}}\"></div>")
  end

  it 'displays nothing if there are no images' do
    allow(collection).to receive(:items).and_return([])

    expect(subject.display).to eq('')
  end
end
