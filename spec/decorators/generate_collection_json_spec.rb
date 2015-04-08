require 'rails_helper'

RSpec.describe GenerateCollectionJSON do
  let(:collection) { instance_double(Collection) }
  let(:collections) { [ collection ]}
  let(:options) { { options: "options"} }

  describe "plural" do
    subject { described_class.call(collections, options) }

    it "generates a collection object" do
      expect_any_instance_of(CollectionJSON).to receive(:to_hash).with(options).and_return({ id: 1 })
      expect(subject).to eq({"collections"=>[{:id=>1}]})
    end
  end

  describe "singular" do
    subject { described_class.call(collection, options) }

    it "generates a singular resource object" do
      expect_any_instance_of(CollectionJSON).to receive(:to_hash).with(options).and_return({ id: 1 })
      expect(subject).to eq({"collections"=>{:id=>1}})
    end
  end
end
