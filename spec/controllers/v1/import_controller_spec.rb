require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ImportController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, items: nil) }
  let(:file) { "file" }
  subject { post :csv, collection_id: collection.id, csv_file: file }

  before(:each) do
    sign_in_admin
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
  end

  it "calls CsvCreateItems with the posted file" do
    expect(CsvCreateItems).to receive(:call).with(collection: collection, file: file)
    subject
  end

  it "renders the result from CsvCreateItems as json" do
    allow(CsvCreateItems).to receive(:call).and_return("json response")
    subject
    expect(response.body).to eq("json response")
  end

  it "checks the editor permissions" do
    allow(CsvCreateItems).to receive(:call).and_return("json response")
    expect_any_instance_of(described_class).to receive(:rendered_forbidden?).with(collection)
    subject
  end
end
