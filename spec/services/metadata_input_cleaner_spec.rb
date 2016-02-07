RSpec.describe MetadataInputCleaner do
  let(:metadata) { {} }
  let(:item) { instance_double(Item, metadata: metadata) }
  subject { described_class.call(item) }

  it "convertes a string to an array" do
    metadata[:string] = "string"
    subject
    expect(item.metadata[:string]).to eq(["string"])
  end

  it "convertes a hash to an array" do
    metadata[:hash] = { hash: "YES" }
    subject
    expect(item.metadata[:hash]).to eq([{ hash: "YES" }])
  end

  it "does nothing to an existing array" do
    metadata[:array] = ["array"]
    subject
    expect(item.metadata[:array]).to eq(["array"])
  end
end
