require 'rails_helper'

describe CreateURLSlug do
  [
    'the collection', # simple title
    'ThE ColleCtion', # caps title
    "the\tcollection", # tab title
    "the\ncollection", # new line title
    "the\rcollection", # carrage return title
    'the  collection', # double space title
    "the\r\ncollection" # carriage new line title
  ].each do |test_title|
    it "converts #{test_title}" do
      expect(described_class.call(test_title)).to eq('the-collection')
    end
  end

  it 'returns title for a blank title ' do
    expect(described_class.call('')).to eq('title')
  end
end
