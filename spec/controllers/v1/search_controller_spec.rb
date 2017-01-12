require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::SearchController, type: :controller do
  let(:collection_configuration) { double(CollectionConfiguration) }
  let(:collection) { instance_double(Collection, id: "1", unique_id: "3", updated_at: nil, items: nil, collection_configuration: collection_configuration) }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
  end

  describe "#index" do
    let(:expected) do {
      collection: collection,
      filters: { collection_id: collection.unique_id },
      q: "query",
      facets: "none",
      sort: "score desc",
      rows: 30,
      start: 0,
    }
    end

    subject {
      get :index,
      collection_id: collection.id,
      q: "query",
      facets: "none",
      sort: "score desc",
      rows: 30,
      start: 0,
      format: :json
    }

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with(collection.id).and_return(collection)

      subject
    end

    it "passes arguments correctly" do
      expect(Waggle).to receive(:search).with(expected)

      subject
    end
  end

  context "#children" do
    let(:group_field) { "part_parent_s" }

    describe "all arguments defined" do
      let(:expected) do {
        collection: collection,
        filters: { collection_id: collection.unique_id },
        q: "-" + group_field + ":_is_parent_ AND query",
        facets: "none",
        sort: "score desc",
        rows: 30,
        start: 0,
        group_by: nil
      }
      end

      subject {
        get :children,
        collection_id: collection.id,
        q: "query",
        facets: "none",
        sort: "score desc",
        rows: 30,
        start: 0,
        no_group: true,
        format: :json
      }

      it "calls CollectionQuery" do
        expect_any_instance_of(CollectionQuery).to receive(:any_find).with(collection.id).and_return(collection)

        subject
      end

      it "passes arguments correctly" do
        expect(Waggle).to receive(:search).with(expected)

        subject
      end
    end

    describe "groups with no query" do
      let(:expected) do {
        collection: collection,
        filters: { collection_id: collection.unique_id },
        q: "-" + group_field + ":_is_parent_ ",
        facets: "none",
        sort: "score desc",
        rows: 30,
        start: 0,
        group_by: group_field
      }
      end

      subject {
        get :children,
        collection_id: collection.id,
        facets: "none",
        sort: "score desc",
        rows: 30,
        start: 0,
        format: :json
      }

      it "passes arguments correctly" do
        expect(Waggle).to receive(:search).with(expected)

        subject
      end
    end

  end
end
