RSpec.describe Waggle::Search::Query do
  let(:arguments) do
    {
      q: "query",
      facets: "facets",
      sort: "sort",
      rows: 20,
      start: 40,
      filters: { collection_id: "collection_id" }
    }
  end

  let(:instance) { described_class.new(**arguments) }

  subject { instance }

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

    it "allows any field to pass through to solr" do
      arguments[:sort] = "theresNoWayThisWillBeInTheConfig"
      expect(subject.sort_field).to eq(arguments[:sort].to_sym)
    end

    it "uses the first string in params as the field name" do
      arguments[:sort] = "one two three"
      expect(subject.sort_field).to eq(:one)
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

    it "accepts asc" do
      arguments[:sort] = "field asc"
      expect(subject.sort_direction).to eq("asc")
    end

    it "accepts desc" do
      arguments[:sort] = "field desc"
      expect(subject.sort_direction).to eq("desc")
    end

    it "defaults to desc if there is a field name, but no direction (same behavior as solr)" do
      expect(subject.sort_direction).to eq("desc")
    end

    it "defaults to desc if invalid second param is given for sort option" do
      arguments[:sort] = "field blah"
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
