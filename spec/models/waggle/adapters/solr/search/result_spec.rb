require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Search::Result do
  let(:raw_response) { File.read(Rails.root.join("spec/fixtures/waggle/solr_response.json")) }
  let(:response) { JSON.parse(raw_response) }

  let(:raw_grouped_response) { File.read(Rails.root.join("spec/fixtures/waggle/solr_grouped_response.json")) }
  let(:grouped_response) { JSON.parse(raw_grouped_response) }

  let(:query) do
    Waggle::Search::Query.new(
      q: "query",
      start: 60,
      rows: 20,
      filters: {},
    )
  end
  let(:configuration) { double(Metadata::Configuration, fields: [], facets: [facet], sort: sort) }
  let(:facet) { double(Metadata::Configuration::Facet, name: "creator", limit: nil) }
  let(:sort) { double(Metadata::Configuration::Sort, field_name: "name", direction: "asc") }

  let(:instance) { described_class.new(query: query) }
  subject { instance }

  before do
    Waggle.set_configuration(configuration)
  end

  context "response" do
    before do
      allow(subject.send(:connection)).to receive(:paginate).and_return(response)
    end

    describe "total" do
      it "is the total number of results" do
        expect(subject.total).to eq(2)
      end
    end

    describe "grouped" do
      it "is grouped" do
        expect(subject.grouped?).to be_falsy
      end
    end

    describe "hits" do
      it "returns an array of hits" do
        expect(subject.hits).to be_kind_of(Array)
        expect(subject.hits.first).to be_kind_of(Waggle::Adapters::Solr::Search::Hit)
      end
    end

    describe "facets" do
      it "returns an array of facets" do
        expect(subject.facets).to be_kind_of(Array)
        expect(subject.facets.first).to be_kind_of(Waggle::Adapters::Solr::Search::Facet)
      end
    end
  end

  context "grouped response" do
    let(:group_query) do
      Waggle::Search::Query.new(
        q: "query",
        start: 0,
        rows: 20,
        filters: {},
        group_by: "part_parent_s",
      )
    end
    let(:group_instance) { described_class.new(query: group_query) }
    subject { group_instance }

    before do
      allow(subject.send(:connection)).to receive(:paginate).and_return(grouped_response)
    end

    describe "total" do
      it "is the total number of results" do
        expect(subject.total).to eq(2)
      end
    end

    describe "grouped" do
      it "is grouped" do
        expect(subject.grouped?).to be_truthy
      end
    end

    describe "groups" do
      it "returns an array of groups" do
        expect(subject.groups).to be_kind_of(Array)
        expect(subject.groups.first).to be_kind_of(Hash)
      end

      it "has the correct grouped keys" do
        expect(subject.groups.first).to have_key(:id)
        expect(subject.groups.first).to have_key(:hits)
        expect(subject.groups.first.fetch(:hits)).to be_kind_of(Array)
      end
    end
  end

  describe "result" do
    it "sends the expected arguments to solr" do
      expect(subject).to receive(:page).exactly(2).times.and_return(2)
      expect(subject).to receive(:per_page).and_return(15)
      expect(subject).to receive(:solr_params).exactly(2).times.and_return(q: "a query")
      expect(subject.send(:connection)).to receive(:paginate).with(
        2,
        15,
        "select",
        params: {
          q: "a query"
        },
      ).and_return("solr_response")
      expect(subject.send(:connection)).to receive(:paginate).with(
        2,
        0,
        "select",
        params: {
          q: "a query"
        },
      ).and_return(nil)
      expect(subject.result).to eq("solr_response")
    end

    it "sends the expected arguments to solr for children" do
      expect(subject).to receive(:page).exactly(2).times.and_return(2)
      expect(subject).to receive(:per_page).and_return(15)
      expect(subject).to receive(:solr_params).exactly(2).times.and_return(
        q: "-part_parent_s:_is_parent_ AND a query",
        group: true,
        :"group.field" => "part_parent_s",
        :"group.limit" => 99999
      )

      expect(subject.send(:connection)).to receive(:paginate).with(
        2,
        15,
        "select",
        params: {
          q: "-part_parent_s:_is_parent_ AND a query",
          group: true,
          :"group.field" => "part_parent_s",
          :"group.limit" => 99999,
        },
      ).and_return("solr_response")
      expect(subject.send(:connection)).to receive(:paginate).with(
        2,
        0,
        "select",
        params: {
          q: "-part_parent_s:_is_parent_ AND a query",
          group: true,
          :"group.field" => "part_parent_s",
          :"group.limit" => 99999,
        },
      ).and_return(nil)
      expect(subject.result).to eq("solr_response")
    end
  end

  describe "solr_params" do
    let(:solr_params) { instance.send(:solr_params) }
    subject { solr_params }

    it "returns the expected params" do
      allow(instance).to receive(:solr_phrase_fields).and_return("phrase_fields")
      allow(instance).to receive(:solr_query_fields).and_return("query_fields")
      allow(instance).to receive(:group).and_return(group: "group_info")
      expect(subject).to eq(
        q: "query",
        fl: "score *",
        fq: [],
        mm: 1,
        qf: "query_fields",
        pf: "phrase_fields",
        sort: "score desc",
        facet: true,
        defType: "edismax",
        :"facet.field" => [
          "{!ex=creator_facet}creator_facet",
        ],
        :"f.creator_facet.facet.limit" => 9999,
        group: "group_info",
      )
    end

    describe "q" do
      subject { solr_params.fetch(:q) }

      it "is the q value from the query" do
        expect(subject).to eq(query.q)
      end
    end

    describe "fl" do
      subject { solr_params.fetch(:fl) }

      it "is the score along with all stored fields" do
        expect(subject).to eq("score *")
      end
    end

    describe "facet" do
      subject { solr_params.fetch(:facet) }

      it "is true" do
        expect(subject).to eq(true)
      end
    end

    describe "facet.fields" do
      subject { solr_params.fetch(:"facet.field") }

      it "is the configured facet fields, excluding their relevant filter" do
        expect(subject).to eq(
          [
            "{!ex=creator_facet}creator_facet"
          ]
        )
      end
    end

    describe "facet.limit" do
      it "always sets facet limit to 9999" do
        allow(facet).to receive(:limit).and_return(9999)
        expect(subject).to include(:"f.creator_facet.facet.limit" => 9999)
      end
    end

    describe "sort" do
      subject { solr_params.fetch(:sort) }

      it "defaults to the score" do
        expect(subject).to eq("score desc")
      end

      it "can be set to another configured sort" do
        allow(query).to receive(:sort).and_return("name asc")
        expect(subject).to eq("name_sort asc")
      end
    end

    describe "group" do
      it "defaults to nothing" do
        expect(subject.fetch("group", nil)).to be_nil
      end

      it "returns group by correct field" do
        allow(query).to receive(:group_by).and_return("group_field")
        expect(subject.fetch(:group, nil)).to be_truthy
        expect(subject.fetch(:"group.field", nil)).to eq("group_field")
        expect(subject.fetch(:"group.limit", nil)).to eq(99999)
      end
    end

    describe "fq" do
      subject { solr_params.fetch(:fq) }

      it "sets fq values for filters" do
        expect(query).to receive(:filters).and_return(collection_id: "animals")
        expect(subject).to eq(["collection_id_s:\"animals\""])
      end

      it "sets fq values for selected facets and tags the filter (single value)" do
        allow(query).to receive(:facet)
        expect(query).to receive(:facet).with("creator").and_return("Steve")
        expect(subject).to eq(["{!tag=creator_facet}creator_facet:\"Steve\""])
      end

      it "sets fq values for selected facets and tags the filter (array of phrases)" do
        allow(query).to receive(:facet)
        expect(query).to receive(:facet).with("creator").and_return(["Steve","Bob","Betty Jane"])
        expect(subject).to eq(["{!tag=creator_facet}creator_facet:(\"Steve\" OR \"Bob\" OR \"Betty Jane\")"])
      end
    end

    describe "qf" do
      subject { solr_params.fetch(:qf) }
      let(:fields) { subject.split(" ") }

      it "includes the catch-all text search fields" do
        expect(fields).to include("text")
        expect(fields).to include("text_unstem_search")
      end

      it "includes configured boosts" do
        fields_with_boost = query.configuration.fields.select { |field| field.boost.present? && field.boost != 1 }
        fields_with_boost.each do |field|
          expect(fields).to include("#{field.name}_t^#{field.boost}")
          expect(fields).to include("#{field.name}_unstem_search^#{field.boost}")
        end
      end
    end
  end
end
