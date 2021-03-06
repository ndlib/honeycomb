require "rails_helper"

RSpec.describe CreateBeehiveURL do
  subject { described_class.call(object) }

  describe "#create" do
    context "Collection" do
      context "custom url flag set to true" do
        let(:object) { Collection.new }
        let(:subject) { CreateBeehiveURL.new(object, true) }

        it "returns a beehive url for a collection" do
          object.name_line_1 = "Test title"
          object.unique_id = "12345"
          expect(subject.create).to eq "http://localhost:3018/12345/test-title"
        end

        it "returns custom slug pattern if present" do
          object.url_slug = "test"
          expect(subject.create).to eq "http://localhost:3018/test"
        end

        it "calls CreateURLSlug on the collection name_line_1" do
          object.name_line_1 = "Test title"
          object.unique_id = "12345"
          expect(subject.create).to eq "http://localhost:3018/12345/test-title"
        end
      end

      context "custom url flag set to false" do
        let(:object) { Collection.new }
        let(:subject) { CreateBeehiveURL.new(object, false) }

        it "returns normal collection url" do
          object.url_slug = "test"
          object.name_line_1 = "Test title"
          object.unique_id = "12345"
          expect(subject.create).to eq "http://localhost:3018/12345/test-title"
        end
      end
    end

    context "Item" do
      let(:collection) { double(Collection, unique_id: "12345678", name_line_1: "A Collection", url_slug: nil) }
      let(:object) { double(Item, unique_id: "87654321", name: "An Item", collection: collection, slug: "An Item") }

      before(:each) do
        allow(collection).to receive(:slug).and_return(collection.name_line_1)
      end

      it "returns a beehive item url" do
        expect(subject).to receive(:create).and_return("http://localhost:3018/12345678/a-collection/items#modal-87654321")
        subject.create
      end

      it "calls CreateURLSlug on the collection and item names" do
        expect(CreateURLSlug).to receive(:call).with(object.collection.name_line_1).and_return("a-collection")
        expect(CreateURLSlug).to receive(:call).with(object.name).and_return("an-item")
        subject
      end
    end
  end

  describe "#call" do
    let(:object) { double(Collection) }

    it "calls create" do
      expect_any_instance_of(CreateBeehiveURL).to receive(:create)
      described_class.call(object)
    end
  end
end
