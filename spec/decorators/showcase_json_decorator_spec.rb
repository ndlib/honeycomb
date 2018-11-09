require "rails_helper"

RSpec.describe ShowcaseJSONDecorator do
  subject { described_class.new(showcase) }

  let(:showcase) { double(Showcase) }

  describe "#at_id" do
    let(:showcase) { double(Showcase, id: "showcase_id") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://localhost:3017/showcases/showcase_id")
    end
  end

  describe "#collection_url" do
    let(:collection) { double(Collection, id: "collection_id") }
    let(:showcase) { double(Showcase, collection: collection) }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://localhost:3017/collections/collection_id")
    end
  end
end
