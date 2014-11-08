require 'rails_helper'

RSpec.describe GenerateItemJson do
  let(:item) { double(Item) }
  let(:items) { [ item ]}
  let(:options) { { options: "options"} }

  subject { GenerateItemJson.call(item, options) }


  describe "collection" do
    subject { GenerateItemJson.call(items, options) }

    it "generates json" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).and_return({ id: 1 })
      expect(subject).to eq({"items"=>[{:id=>1}]})
    end

    it "uses ItemJson to generate the hash with the options" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).with(options)
      subject
    end
  end


  describe "resource" do

    it "generates json" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).and_return({ id: 1 })
      expect(subject).to eq({"items"=>{:id=>1}})
    end

    it "uses ItemJson to generate the hash with the options" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).with(options)
      subject
    end

  end
end
