require "rails_helper"

describe CreateURLSlug do
  [
    "the collection", # simple name
    "ThE ColleCtion", # caps name
    "the\tcollection", # tab name
    "the\ncollection", # new line name
    "the\rcollection", # carrage return name
    "the  collection", # double space name
    "the\r\ncollection" # carriage new line name
  ].each do |test_name|
    it "converts #{test_name}" do
      expect(described_class.call(test_name)).to eq("the-collection")
    end
  end

  it "returns name for a blank name " do
    expect(described_class.call("")).to eq("name")
  end
end
