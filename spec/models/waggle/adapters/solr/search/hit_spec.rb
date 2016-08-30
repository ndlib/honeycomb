require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Search::Hit do
  let(:raw_response) { File.read(Rails.root.join("spec/fixtures/waggle/solr_response.json")) }
  let(:response) { JSON.parse(raw_response) }
  let(:solr_doc) { response.fetch("response").fetch("docs").first }
  let(:instance) { described_class.new(solr_doc) }
  subject { instance }

  describe "id" do
    it "is the id" do
      expect(subject.id).to eq(solr_doc.fetch("id"))
    end
  end

  describe "name" do
    it "is the name" do
      expect(subject.name).to eq(solr_doc.fetch("name_t").first)
    end
  end

  [:at_id, :unique_id, :collection_id, :type, :thumbnail_url].each do |field|
    it "returns the string #{field}" do
      expect(subject.send(field)).to eq(solr_doc.fetch("#{field}_s"))
    end
  end

  [:last_updated].each do |field|
    it "returns the datetime #{field}" do
      expect(subject.send(field)).to eq(solr_doc.fetch("#{field}_dt"))
    end
  end

  describe "last_updated" do
    it "is a DateTime" do
      expect(subject.last_updated).to be_kind_of(DateTime)
    end
  end

  describe "description" do
    it "it is text" do
      expect(subject.description).to be_kind_of(String)
    end

    it "fetches the description" do
      expect(subject).to receive(:fetch_text).with(:description)
      subject.description
    end
  end

  describe "media" do
    it "it is a hash" do
      expect(subject.media).to be_kind_of(Hash)
    end

    it "fetches the media" do
      expect(subject).to receive(:fetch_string).with(:media).and_return('{"test" => "test"}')
      subject.media
    end
  end

  describe "creator" do
    it "it is text" do
      expect(subject.creator).to be_kind_of(String)
    end

    it "feteches the description" do
      expect(subject).to receive(:fetch_text).with(:creator)
      subject.creator
    end
  end

  describe "date_created" do
    it "it is String" do
      expect(subject.date_created).to be_kind_of(String)
    end

    it "fetches the date_created" do
      expect(subject).to receive(:fetch_text).with(:date_created)
      subject.date_created
    end
  end
end
