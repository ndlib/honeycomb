RSpec.describe Waggle::Search::Query do
  let(:arguments) do
    {
      q: "query",
      facets: "facets",
      sort: "sort",
      rows: 20,
      start: 40,
      filters: { collection_id: "collection_id" },
      group_by: "group_field",
    }
  end
  let(:configuration) { double(Metadata::Configuration, fields: [], facets: [facet], sort: sort) }
  let(:facet) { double(Metadata::Configuration::Facet, name: "creator") }
  let(:sort) { double(Metadata::Configuration::Sort, field_name: "name", direction: "asc") }
  let(:instance) { described_class.new(**arguments) }

  subject { instance }

  before(:each) do
    allow(Waggle).to receive(:configuration).and_return(configuration)
  end

  it "initializes and sets arguments" do
    arguments.each do |key, value|
      expect(subject.send(key)).to eq(value)
    end
  end

  describe "sort_field" do
    it "returns nil if no sort given" do
      arguments.delete(:sort)
      expect(subject.sort_field).to eq(nil)
    end

    it "returns nil if sort given is empty string" do
      arguments[:sort] = ""
      expect(subject.sort_field).to eq(nil)
    end

    context "when the requested field is present in the config" do
      before(:each) do
        allow(configuration).to receive(:sort).and_return(sort)
      end

      it "uses the field name from the config" do
        expect(subject.sort_field).to eq(sort.field_name)
      end
    end

    context "when the requested field is not present in the config" do
      before(:each) do
        allow(configuration).to receive(:sort).and_return(nil)
      end

      it "allows pass-through to solr" do
        expect(subject.sort_field).to eq(arguments[:sort].to_sym)
      end

      it "uses the first string in params as the field name" do
        arguments[:sort] = "one two three"
        expect(subject.sort_field).to eq(:one)
      end
    end
  end

  describe "sort_direction" do
    it "returns nil if no sort given" do
      arguments.delete(:sort)
      expect(subject.sort_direction).to eq(nil)
    end

    it "returns nil if sort given is empty string" do
      arguments[:sort] = ""
      expect(subject.sort_direction).to eq(nil)
    end

    it "accepts asc as an override parameter" do
      arguments[:sort] = "field asc"
      expect(subject.sort_direction).to eq("asc")
    end

    it "accepts desc as an override parameter" do
      arguments[:sort] = "field desc"
      expect(subject.sort_direction).to eq("desc")
    end

    it "uses the configuration direction when no direction is given in the arguments" do
      expect(subject.sort_direction).to eq(sort.direction)
    end

    it "defaults to desc if there is a field name, but no direction is given in the arguments or the config" do
      allow(configuration).to receive(:sort).and_return(nil)
      expect(subject.sort_direction).to eq("desc")
    end

    it "defaults to desc if invalid second param is given for sort option" do
      arguments[:sort] = "field blah"
      expect(subject.sort_direction).to eq("desc")
    end

    it "defaults to desc if there is a field name, but no direction is given in the arguments or the config" do
      allow(sort).to receive(:direction).and_return("blah")
      expect(subject.sort_direction).to eq("desc")
    end
  end

  describe "result" do
    subject { instance.result }
    it "returns a Waggle::Search::Result" do
      expect(Waggle::Search::Result).to receive(:new).with(query: instance).and_call_original
      expect(subject).to be_kind_of(Waggle::Search::Result)
    end
  end
end
