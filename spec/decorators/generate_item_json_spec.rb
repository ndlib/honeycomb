require 'rails_helper'

RSpec.describe GenerateItemJSON do
  let(:item) { instance_double(Item) }
  let(:items) { [ item ]}
  let(:options) { { options: "options"} }

  describe "plural" do
    subject { described_class.call(items, options) }

    it "generates a collection object" do
      expect_any_instance_of(ItemJSON).to receive(:to_hash).with(options).and_return({ id: 1 })
      expect(subject).to eq({"items"=>[{:id=>1}]})
    end
  end

  describe "singular" do
    subject { described_class.call(item, options) }

    it "generates a singular resource object" do
      expect_any_instance_of(ItemJSON).to receive(:to_hash).with(options).and_return({ id: 1 })
      expect(subject).to eq({"items"=>{:id=>1}})
    end
  end
end
