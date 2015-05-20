require "rails_helper"

RSpec.describe ItemDecorator do
  let(:item) { instance_double(Item, title: "title", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection_id: collection.id, collection: collection, image: "image.jpg") }
  let(:collection) { instance_double(Collection, id: 2, title: "title") }

  subject { described_class.new(item) }

  [:id, :title, :description].each do |field|
    it "delegates #{field}" do
      expect(subject.send(field)).to eq(item.send(field))
    end
  end

  describe "#recent_children" do
    it "returns a decorated collection" do
      children = ["item"]
      expect(subject).to receive(:children_query_recent).and_return(children)
      expect(ItemsDecorator).to receive(:new).with(children).and_call_original
      expect(subject.recent_children).to be_a_kind_of(ItemsDecorator)
    end
  end

  describe "#recent_children_objects" do
    it "queries items" do
      expect_any_instance_of(ItemQuery).to receive(:recent).and_return([])
      expect(item).to receive(:children).and_return(Item.all)
      expect(subject.recent_children).to eq([])
    end
  end

  describe "#item_meta_data_form" do
    let(:collection) { double(Collection, id: 2 )}
    let(:item) { double(Item, id: 1, title: "title", description: "description", transcription: "transcription", manuscript_url: "manuscript_url", collection: collection) }

    it "rends the react component" do
      allow(subject.h).to receive(:form_authenticity_token).and_return("token")
      expect(subject.h).to receive(:react_component).with(
        "ItemMetaDataForm",
        authenticityToken: "token",
        url: "/items/1",
        returnUrl: "/collections/2/items",
        method: "put",
        data: {
          title: "title",
          description: "description",
          transcription: "transcription",
          manuscript_url: "manuscript_url"
        }
      )

      subject.item_meta_data_form
    end
  end

  describe "honeypot image" do
    let(:honeypot_image) { instance_double(HoneypotImage, title: "Image Title", url: "http://example.com/image", image_json: {}) }
    before do
      allow(item).to receive(:honeypot_image).and_return(honeypot_image)
    end

    describe "#image_title" do
      it "is the image title" do
        expect(subject.image_title).to eq("Image Title")
      end
    end

    describe "#show_image_box" do
      it "renders a react component" do
        expect(subject.show_image_box).to match("<div data-react-class=\"ItemShowImageBox\"")
      end
    end
  end

  context "parent item" do
    before do
      allow(item).to receive(:parent_id).and_return(nil)
    end

    it "returns true for is_parent?" do
      expect(subject.is_parent?).to be_truthy
    end

    describe "#back_path" do
      it "is the collection items index" do
        expect(subject.back_path).to eq("/collections/#{collection.id}")
      end
    end
  end

  context "child item" do
    let(:child_item) { instance_double(Item, title: "Child Item", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 2, collection_id: collection.id, collection: collection, image: "image.jpg", parent_id: 1) }
    subject { described_class.new(child_item) }

    it "returns false for is_parent?" do
      expect(subject.is_parent?).to be_falsey
    end

    describe "#back_path" do
      it "is the parent show route" do
        expect(subject.back_path).to eq("/items/#{child_item.parent_id}/children")
      end
    end
  end

  it "returns the edit path" do
    expect(subject.edit_path).to eq("/items/1/edit")
  end
end
