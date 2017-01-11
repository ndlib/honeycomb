RSpec.describe Waggle::Adapters::Solr::Session do
  let(:instance) { described_class.new }

  describe "config" do
    let(:default_config) { YAML.load_file(File.join(Rails.root, "config", "solr.yml")).fetch(Rails.env) }
    it "defaults to the values configured in config/solr.yml" do
      expect(subject.config).to eq(default_config)
    end

    context "custom config" do
      let(:config) { { test: "test" } }
      subject { described_class.new(config) }
      it "accepts a custom configuration" do
        expect(subject.config).to eq(config)
      end
    end
  end

  describe "connection" do
    subject { described_class.new.connection }

    it "builds an RSolr client" do
      expect(RSolr).to receive(:connect).with(
        url: "http://localhost:8981/solr/test",
        read_timeout: nil,
        open_timeout: nil,
      ).and_call_original
      expect(subject).to be_kind_of(RSolr::Client)
    end
  end

  context "indexing" do
    let(:items) { [instance_double(Waggle::Item, id: "item-1", type: "Item", collection_id: "collection-1", parent: nil), instance_double(Waggle::Item, id: "item-2", type: "Item", collection_id: "collection-2", parent: nil)] }
    let(:connection) { instance_double(RSolr::Client) }

    before do
      allow_any_instance_of(described_class).to receive(:connection).and_return(connection)
    end

    describe "index" do
      subject { instance.index(*items) }

      it "maps objects to solr objects and indexes their as_solr values" do
        items.each do |waggle_item|
          expect(Waggle::Adapters::Solr::Index::Item).to receive(:new).with(waggle_item: waggle_item).and_call_original
        end
        allow_any_instance_of(Waggle::Adapters::Solr::Index::Item).to receive(:as_solr).and_return(test: "test")
        expect(connection).to receive(:add).with([{ test: "test" }, { test: "test" }])
        subject
      end
    end

    describe "index!" do
      subject { instance.index!(*items) }

      it "calls index and commit" do
        expect(instance).to receive(:index).with(*items)
        expect(instance).to receive(:commit)
        subject
      end
    end

    describe "remove" do
      subject { instance.remove(*items) }

      it "maps objects to solr objects and indexes their as_solr values" do
        items.each do |waggle_item|
          expect(Waggle::Adapters::Solr::Index::Item).to receive(:new).with(waggle_item: waggle_item).and_call_original
        end
        expect(connection).to receive(:delete_by_id).with(["collection-1 item-1", "collection-2 item-2"])
        subject
      end
    end

    describe "remove!" do
      subject { instance.remove!(*items) }

      it "calls remove and commit" do
        expect(instance).to receive(:remove).with(*items)
        expect(instance).to receive(:commit)
        subject
      end
    end

    describe "commit" do
      subject { instance.commit }
      it "calls commit on the connection" do
        expect(connection).to receive(:commit)
        subject
      end
    end
  end
end
