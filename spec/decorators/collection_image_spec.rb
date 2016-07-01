require "rails_helper"

RSpec.describe CollectionImage do
  subject { described_class.new(collection) }

  let(:collection) { instance_double(Collection, id: 2, image: collection_image, items: items) }
  let(:image) { instance_double(ActiveRecord::AssociationRelation, first: item_with_image) }
  let(:items) { instance_double(ActiveRecord::Associations::CollectionProxy, joins: image) }
  let(:item_with_image) { double(Item, image: honeypot_image) }
  let(:item_with_no_image) { double(Item, image: nil) }
  let(:collection_image) { double(HoneypotImage, url: "http://image.collection.com/image", json_response: { contentUrl: "http://collection.com/image.jpg" }) }
  let(:honeypot_image) { double(HoneypotImage, url: "http://image.image.com/image", json_response: { contentUrl: "http://example.com/image.jpg" }) }

  it "uses the item decorator to call the image display" do
    allow(image).to receive(:first).and_return(item_with_image)
    expect_any_instance_of(HoneypotThumbnail).to receive(:display)
    subject.display
  end

  it "displays the first image found if the collection has none" do
    allow(collection).to receive(:image).and_return(nil)
    expect(subject.display).to eq("<div " \
      "data-react-class=\"Thumbnail\" " \
      "data-react-props=\"{&quot;image&quot;:{&quot;contentUrl&quot;:&quot;http://example.com/image.jpg&quot;}}\">" \
      "</div>")
  end

  it "displays the collection image even if an item has an image" do
    allow(image).to receive(:first).and_return(item_with_image)
    expect(subject.display).to eq("<div " \
      "data-react-class=\"Thumbnail\" " \
      "data-react-props=\"{&quot;image&quot;:{&quot;contentUrl&quot;:&quot;http://collection.com/image.jpg&quot;}}\">" \
      "</div>")
  end

  it "displays nothing if there are no images" do
    allow(image).to receive(:first).and_return(nil)
    allow(collection).to receive(:image).and_return(nil)

    expect(subject.display).to eq("")
  end
end
