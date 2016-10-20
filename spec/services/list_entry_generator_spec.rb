require "rails_helper"

RSpec.describe ListEntryGenerator do
  let(:collection) do
    instance_double(Collection,
                    unique_id: 1,
                    id: 1,
                    name_line_1: "COLLECTION",
                    destroy!: true,
                    collection_configuration: nil,
                    collection_users: [],
                    showcases: Showcase.all,
                    pages: Page.all,
                    items: [],
                    updated_at: "0",
                    image: image)
  end
  let(:showcase) do
    instance_double(Showcase,
                    unique_id: 1,
                    name_line_1: "name_line_1",
                    collection: collection,
                    sections: [],
                    destroy!: true,
                    updated_at: "0",
                    image: nil)
  end
  let(:page) do
    instance_double(Page,
                    unique_id: 1,
                    name: "name",
                    collection: collection,
                    items: [],
                    destroy!: true,
                    updated_at: "0",
                    image: nil)
  end
  let(:image) { instance_double(Image, json_response: { "contentUrl" => "img" }) }

  let(:collection_param) { [collection] }
  let(:page_param) { [page] }
  let(:showcase_param) { [showcase] }

  describe "collections" do
    subject { described_class.collection_entries(collection_param) }

    it "uses correct entry generator" do
      expect_any_instance_of(described_class).to receive(:build).with(:collection_entry)

      subject
    end

    it "returns list of 1 entry" do
      expect(subject).not_to be_empty
    end

    it "converts correctly" do
      returned = subject[0]

      expect(returned[:id]).to eq(collection.unique_id)
      expect(returned[:name]).to eq(collection.name_line_1)
      expect(returned[:updated]).to eq(collection.updated_at)
      expect(returned[:thumb]).to eq("img")
      expect(returned[:count]).to eq(collection.items.size)
    end
  end

  describe "pages" do
    subject { described_class.page_entries(page_param) }

    it "uses correct entry generator" do
      expect_any_instance_of(described_class).to receive(:build).with(:page_entry)

      subject
    end

    it "returns list of 1 entry" do
      expect(subject).not_to be_empty
    end

    it "converts correctly" do
      returned = subject[0]

      expect(returned[:id]).to eq(page.unique_id)
      expect(returned[:name]).to eq(page.name)
      expect(returned[:updated]).to eq(page.updated_at)
      expect(returned[:thumb]).to eq(page.image)
    end
  end

  describe "showcases" do
    subject { described_class.showcase_entries(showcase_param) }

    it "uses correct entry generator" do
      expect_any_instance_of(described_class).to receive(:build).with(:showcase_entry)

      subject
    end

    it "returns list of 1 entry" do
      expect(subject).not_to be_empty
    end

    it "converts correctly" do
      returned = subject[0]

      expect(returned[:id]).to eq(showcase.unique_id)
      expect(returned[:name]).to eq(showcase.name_line_1)
      expect(returned[:updated]).to eq(showcase.updated_at)
      expect(returned[:thumb]).to eq(showcase.image)
    end
  end

end