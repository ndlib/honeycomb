require "rails_helper"

RSpec.describe MetadataDate do
  
  describe :date_parsing do
    {
      '2012-12-12' => [2012, 12, 12],
      '0010-1-2' => [10, 1, 2],
      '190-03-22' => [190, 3, 22],
      '19-12-05' => [19, 12, 5],
      '1-12-22' => [1, 12, 22],
      '-1190-12-22' => [-1190, 12, 22],
      '-110-12' => [-110, 12, nil],
      '1000-03' => [1000, 3, nil],
      '0010-11' => [10, 11, nil],
      '10-11' => [10, 11, nil],
      '5-3' => [5, 3, nil],
      '-2125-03' => [-2125, 3, nil],
      '-2125' => [-2125, nil, nil],
      '2121' => [2121, nil, nil],
      '121' => [121, nil, nil],
      '0121' => [121, nil, nil],
      '0021' => [21, nil, nil],
      '21' => [21, nil, nil],
      '0002' => [2, nil, nil],
      '2' => [2, nil, nil],
    }.each do | date, expected |
      it "parses #{date}" do
        date = MetadataDate.new({ value: date })
        expect(date.year).to eq(expected[0])
        expect(date.month).to eq(expected[1])
        expect(date.day).to eq(expected[2])
      end
    end

    [
      'asdf-da-as',
      'sd23-10-21',
      '2012-15-21',
      '2012-10-41',
    ].each do | date |
      it "fails on the invalid format of #{date}" do
        expect{ MetadataDate.new({ value: date })}.to raise_error
      end
    end
  end

  describe :bc? do

    it "is true when the date is BC" do
      date = MetadataDate.new({ value: '-2322' })
      expect(date.bc?).to be_truthy
    end

    it "is false when the date is AD" do
      date = MetadataDate.new({ value: '2322' })
      expect(date.bc?).to be_falsey
    end
  end

  describe :display_text do

    it "uses FormatDisplayText to determine how to format display text" do
      date = MetadataDate.new({ value: '2322', display_text: 'display-text' })
      expect(MetadataDate::FormatDisplayText).to receive(:format).with(date)
      date.display_text
    end

  end

end
