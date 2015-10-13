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
      image: "image.jpg",
      showcases: { showcases: {} }
    }
  end
  let(:item) { instance_double(Item, item_stubs) }
  let(:collection) { instance_double(Collection, id: 2, name_line_1: "name_line_1") }
  let(:attachment) { double(Paperclip::Attachment, exists?: true, url: "image.jpg") }

  subject { described_class.new(item) }

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
    let(:collection) { double(Collection, id: 2) }
    let(:item) do
      double(
        Item,
        id: 1,
        unique_id: "unique_id",
        name: "name",
        description: "description",
        transcription: "transcription",
        manuscript_url: "manuscript_url",
        creator: "creator",
        alternate_name: "alternate_name",
        rights: "rights",
        call_number: "call_number",
        original_language: "original_language",
        collection: collection,
        contributor: "contributor",
        subject: "subject",
        publisher: "publisher",
        provenance: "provenance",
        date_created: "date_created",
        date_modified: "date_modified",
        date_published: "date_published",
        user_defined_id: 1)
    end

    it "renders the react component" do
      allow(subject.h).to receive(:form_authenticity_token).and_return("token")
      expect(subject.h).to receive(:react_component).with(
        "ItemMetaDataForm",
        authenticityToken: "token",
        url: "/v1/items/unique_id",
        method: "put",
        data: {
          name: "name",
          description: "description",
          transcription: "transcription",
          manuscript_url: "manuscript_url",
          creator: "creator",
          contributor: "contributor",
          subject: "subject",
          publisher: "publisher",
          alternate_name: "alternate_name",
          rights: "rights",
          call_number: "call_number",
          provenance: "provenance",
          original_language: "original_language",
          date_created: "date_created",
          date_modified: "date_modified",
          date_published: "date_published",
          user_defined_id: 1
        }
      )

      subject.item_meta_data_form
    end
  end

  describe "honeypot image" do
    let(:honeypot_image) { instance_double(HoneypotImage, name: "Image Name", url: "http://example.com/image", image_json: {}) }
    before do
      allow(item).to receive(:honeypot_image).and_return(honeypot_image)
    end

    describe "#image_name" do
      it "is the image name" do
        expect(subject.image_name).to eq("Image Name")
      end
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
        image: "image.jpg",
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
      allow(item).to receive(:image_ready?).and_return(false)
      allow(item).to receive(:no_image?).and_return(false)
      allow(item).to receive(:image_processing?).and_return(false)
      allow(item).to receive(:image_invalid?).and_return(false)
    end

    it "renders the correct success span when the image is ready" do
      expect(item).to receive(:image_ready?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-success", icon: "ok", text: "OK")
      subject.status_text
    end

    it "renders the correct success span when the image is invalid" do
      expect(item).to receive(:image_invalid?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-danger", icon: "minus", text: "Error")
      subject.status_text
    end

    it "renders the correct success span when the image is invalid" do
      expect(item).to receive(:no_image?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-success", icon: "ok", text: "No Image")
      subject.status_text
    end

    it "renders the correct success span when the image is processing" do
      expect(item).to receive(:image_processing?).and_return(true)
      expect(subject).to receive(:status_text_span).with(className: "text-info", icon: "minus", text: "Processing")
      subject.status_text
    end
  end
end
