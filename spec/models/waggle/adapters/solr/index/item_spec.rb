require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Index::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:waggle_item) { Waggle::Item.new(data) }
  let(:configuration) { double(Metadata::Configuration, fields: [], facets: [], sorts: []) }
  let(:metadata) do
    double(
      as_solr: {
        name_t: ["pig-in-mud"],
        name_sort: "pig-in-mud",
        creator_facet: ["Bob"],
        creator_sort: "Bob",
        creator_t: ["Bob"],
        date_published_t: ["2013-03-24"],
        description_t: ["Source"]
      }
    )
  end
  subject { described_class.new(waggle_item: waggle_item) }

  before(:each) do
    Waggle.set_configuration(configuration)
    allow(subject).to receive(:metadata).and_return(metadata)
  end

  describe "id" do
    it "is the id plus type" do
      expect(subject.id).to eq("#{data.fetch('id')} Item")
    end
  end

  describe "as_solr" do
    it "is the hash to send to solr" do
      expect(subject.as_solr).to eq(
        name_t: ["pig-in-mud"],
        creator_t: ["Bob"],
        description_t: ["Source"],
        date_published_t: ["2013-03-24"],
        creator_facet: ["Bob"],
        name_sort: "pig-in-mud",
        creator_sort: "Bob",
        id: "pig-in-mud Item",
        at_id_s: "http://localhost:3017/v1/items/pig-in-mud",
        unique_id_s: "pig-in-mud",
        collection_id_s: "animals",
        type_s: "Item",
        thumbnail_url_s: "http://localhost:3019/images/honeycomb/000/001/000/013/medium/pig-in-mud.jpg",
        media_s: "{\"@context\"=>\"http://schema.org\", \"@type\"=>\"ImageObject\", \"@id\"=>\"http://localhost:3019/api/v1/images/honeycomb/000/001/000/013/pig-in-mud.jpg\", \"width\"=>\"4898 px\", \"height\"=>\"3265 px\", \"encodingFormat\"=>\"jpeg\", \"contentUrl\"=>\"http://localhost:3019/images/honeycomb/000/001/000/013/pig-in-mud.jpg\", \"name\"=>\"pig-in-mud.jpg\", \"thumbnail/medium\"=>{\"@type\"=>\"ImageObject\", \"width\"=>\"1200 px\", \"height\"=>\"800 px\", \"encodingFormat\"=>\"jpeg\", \"contentUrl\"=>\"http://localhost:3019/images/honeycomb/000/001/000/013/medium/pig-in-mud.jpg\"}, \"thumbnail/dzi\"=>{\"@type\"=>\"ImageObject\", \"width\"=>\"4898 px\", \"height\"=>\"3265 px\", \"encodingFormat\"=>\"dzi\", \"contentUrl\"=>\"http://localhost:3019/images/honeycomb/000/001/000/013/pyramid/pig-in-mud.tif.dzi\"}, \"thumbnail/small\"=>{\"@type\"=>\"ImageObject\", \"width\"=>\"300 px\", \"height\"=>\"200 px\", \"encodingFormat\"=>\"jpeg\", \"contentUrl\"=>\"http://localhost:3019/images/honeycomb/000/001/000/013/small/pig-in-mud.jpg\"}}",
        last_updated_dt: "2015-08-04T12:47:17Z",
        last_updated_sort: "2015-08-04T12:47:17Z",
        title_t: ["pig-in-mud"],
      )
    end
  end
end
