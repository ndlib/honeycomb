require 'rails_helper'

describe CreateURLSlug do

  let(:simple_title) { "the collection" }
  let(:caps_title) { "ThE ColleCtion"}
  let(:tab_title) { "the\tcollection"}
  let(:newline_title) { "the\ncollection"}
  let(:return_title) {"the\rcollection"}
  let(:double_space_title) { "the  collection"}
  let(:nlcr_title) { "the\r\ncollection"}
  let(:non_alpha_title) { "th.e colle.ct.ion"}

  [:simple_title, :caps_title, :tab_title, :newline_title, :return_title, :double_space_title, :non_alpha_title].each do |test_title|
    it "converts #{test_title}" do
      title = eval(test_title.to_s)
      expect(described_class.call(title)).to eq("the-collection")
    end
  end

  it "returns title for a blank title " do
    expect(described_class.call('')).to eq("title")
  end
end
