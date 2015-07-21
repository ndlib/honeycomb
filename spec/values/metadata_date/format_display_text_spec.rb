require "rails_helper"

RSpec.describe MetadataDate::FormatDisplayText do

  it "returns the display text field when there is a display text" do
    date = double(MetadataDate, display_text: "Text to display")
    expect(MetadataDate::FormatDisplayText.format(date)).to eq("Text to display")
  end

  it "returns the year month day format when all are present" do
    date = double(MetadataDate, display_text: nil, date: Date.new(1000, 10, 5), bc?: false, day: 5, month: 10, year: 1000)
    expect(MetadataDate::FormatDisplayText.format(date)).to eq('October 05, 1000')
  end

  it "returns the year month format when all are present" do
    date = double(MetadataDate, display_text: nil, date: Date.new(1000, 10, 10), bc?: false, day: nil, month: 10, year: 1000)
    expect(MetadataDate::FormatDisplayText.format(date)).to eq('October, 1000')
  end

  it "returns the year format when all are present" do
    date = double(MetadataDate, display_text: nil, date: Date.new(1000, 10, 10), bc?: false, day: nil, month: nil, year: 1000)
    expect(MetadataDate::FormatDisplayText.format(date)).to eq('1000')
  end

  it "adds BC when the year is BC" do
    date = double(MetadataDate, display_text: nil, date: Date.new(-1000, 10, 10), bc?: true, day: 10, month: 10, year: -1000)
    expect(MetadataDate::FormatDisplayText.format(date)).to match(/ BC$/)
  end

  it "when the date is BC year is displayed in the possitive" do
    date = double(MetadataDate, display_text: nil, date: Date.new(-1000, 10, 10), bc?: true, day: 10, month: 10, year: -1000)
    expect(MetadataDate::FormatDisplayText.format(date)).to_not include('-1000')
  end

end
