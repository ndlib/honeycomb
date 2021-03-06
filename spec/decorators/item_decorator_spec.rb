require "rails_helper"

RSpec.describe ItemDecorator do
  let(:item_stubs) do
    {
      name: "name",
      description: "description",
      updated_at: "2014-11-06 11:45:52 -0500",
      id: 1,
      collection_id: collection.id,
      collection: collection,
      media: image,
      showcases: { showcases: {} },
      pages: { pages: {} },
    }
  end
  let(:item) { instance_double(Item, item_stubs) }
  let(:image) { instance_double(Image) }
  let(:collection) { instance_double(Collection, id: 2, name_line_1: "name_line_1", unique_id: "unique_id") }
  let(:attachment) { double(Paperclip::Attachment, exists?: true, url: "image.jpg") }

  subject { described_class.new(item) }

  before(:each) do
    allow(CreateBeehiveURL).to receive(:call).and_return("url")
  end

  [:id, :name, :description].each do |field|
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
    let(:collection) { double(Collection, id: 2, collection_configuration: double, unique_id: "unique_id") }
    let(:metadata) do
      {
        metadata: [double(value: "value")]
      }
    end
    let(:item) do
      double(
        Item,
        id: 1,
        unique_id: "unique_id",
        collection: collection,
        name: "name",
      )
    end

    before(:each) do
      allow_any_instance_of(Metadata::Fields).to receive(:fields).and_return(metadata)
    end

    it "renders the react component" do
      allow(subject.h).to receive(:form_authenticity_token).and_return("token")
      allow(item).to receive(:showcases).and_return([])
      allow(item).to receive(:pages).and_return([])
      allow(item).to receive(:children).and_return([])
      expect(subject.h).to receive(:react_component).with(
        "ItemForm",
        id: "unique_id",
        authenticityToken: "token",
        url: "/v1/items/unique_id",
        method: "put",
        data: { metadata: ["value"] },
        embedBaseUrl: "url",
        previewUrl: "url",
        canDelete: true
      )

      subject.item_meta_data_form
    end
  end

  describe "image" do
    let(:image) { instance_double(Image, json_response: {}) }
    before do
      allow(item).to receive(:media).and_return(image)
    end

    describe "#show_image_box" do
      it "renders a react component" do
        allow(item).to receive(:unique_id).and_return("unique_id")
        expect_any_instance_of(V1::ItemJSONDecorator).to receive(:to_hash).and_return("ITEMHASH")

        expect(subject.h).
          to receive(:react_component).
          with("ItemShowImageBox", item: "ITEMHASH", itemPath: "/v1/items/unique_id").
          and_return(nil)
        subject.show_image_box
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

  context "showcases_json" do
    it "renders the json partial from the showcases view" do
      expect(subject.h).to receive(:render).with(partial: "showcases/showcases", formats: [:json], locals: { showcases: item.showcases })
      subject.showcases_json
    end
  end

  context "pages_json" do
    it "renders the json partial from the pages view" do
      expect(subject.h).to receive(:render).with(partial: "pages/pages", formats: [:json], locals: { pages: item.pages })
      subject.pages_json
    end
  end

  context "page_name" do
    it "renders the item_name partial" do
      expect(subject.h).to receive(:render).with(partial: "/items/item_name", locals: { item: subject })
      subject.page_name
    end
  end

  context "child item" do
    let(:child_stubs) do
      {
        name: "Child Item",
        description: "description",
        updated_at: "2014-11-06 11:45:52 -0500",
        id: 2,
        collection_id: collection.id,
        collection: collection,
        media: "image.jpg",
        parent_id: 1
      }
    end
    let(:child_item) { instance_double(Item, child_stubs) }
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

  context "status_text" do
    before(:each) do
      allow(image).to receive(:ready?).and_return(false)
      allow(image).to receive(:processing?).and_return(false)
      allow(image).to receive(:unavailable?).and_return(false)
    end

    it "renders the correct success span when the image is ready" do
      expect(image).to receive(:ready?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-success", icon: "ok", text: "OK")
      subject.status_text
    end

    it "renders the correct success span when the image is invalid" do
      expect(image).to receive(:unavailable?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-danger", icon: "minus", text: "Error")
      subject.status_text
    end

    it "renders the correct success span when the image is invalid" do
      expect(item).to receive(:media).and_return(nil)
      expect(subject).to receive(:status_text_span).with(className: "text-success", icon: "ok", text: "No Image")
      subject.status_text
    end

    it "renders the correct success span when the image is processing" do
      expect(image).to receive(:processing?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-info", icon: "minus", text: "Processing")
      subject.status_text
    end
  end
end
