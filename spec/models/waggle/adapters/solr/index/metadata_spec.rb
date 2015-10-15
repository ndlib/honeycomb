require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Index::Metadata do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items").fetch("metadata") }
  let(:configuration) { Metadata::Configuration.item_configuration }
  let(:metadata_set) { Waggle::Metadata::Set.new(data, configuration) }
  subject { described_class.new(metadata_set: metadata_set) }

  describe "as_solr" do
    it "builds a hash to send to solr" do
      expect(subject.as_solr).to eq(
        name_t: ["pig-in-mud"],
        creator_t: ["Bob"],
        description_t: ["Source: https://pixabay.com/en/pig-sow-animal-portrait-752555/"],
        date_published_t: ["2013-03-24"],
        creator_facet: ["Bob"],
        name_sort: "pig-in-mud",
        creator_sort: "Bob",
      )
    end
  end
end