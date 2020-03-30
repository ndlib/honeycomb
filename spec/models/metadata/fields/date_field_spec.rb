require "rails_helper"

RSpec.describe Metadata::Fields::DateField do
  describe "#from_hash" do
    let(:hash) { { year: "2015", month: "7", day: "15" } }

    it "works with string keys" do
      expect(Metadata::Fields::DateField).to receive(:new).with(hash)
      Metadata::Fields::DateField.from_hash(hash.stringify_keys)
    end

    it "works with symbol keys" do
      expect(Metadata::Fields::DateField).to receive(:new).with(hash)
      Metadata::Fields::DateField.from_hash(hash)
    end
  end

  describe "year" do
    it "passes the value of the year field " do
      date = Metadata::Fields::DateField.new(year: "year")
      expect(date.year).to eq("year")
    end

    it "returns nil if there is nothing passed in for year" do
      date = Metadata::Fields::DateField.new({})
      expect(date.year).to eq(nil)
    end
  end

  describe "month" do
    it "passes the value of the month field " do
      date = Metadata::Fields::DateField.new(month: "month")
      expect(date.month).to eq("month")
    end

    it "returns nil if there is nothing passed in for month" do
      date = Metadata::Fields::DateField.new({})
      expect(date.month).to eq(nil)
    end
  end

  describe "day" do
    it "passes the value of the day field " do
      date = Metadata::Fields::DateField.new(year: "day")
      expect(date.year).to eq("day")
    end

    it "returns nil if there is nothing passed in for day" do
      date = Metadata::Fields::DateField.new({})
      expect(date.day).to eq(nil)
    end
  end

  describe "bc?" do
    it "is true when the date is BC" do
      date = Metadata::Fields::DateField.new(bc: "true")
      expect(date.bc?).to be(true)
    end

    it "is true when the date is true" do
      date = Metadata::Fields::DateField.new(bc: true)
      expect(date.bc?).to be(true)
    end

    it "is false when the date is AD" do
      date = Metadata::Fields::DateField.new(bc: "false")
      expect(date.bc?).to be_falsey
    end

    it "is false when the date is false" do
      date = Metadata::Fields::DateField.new(bc: false)
      expect(date.bc?).to be_falsey
    end

    it "is false when the date is nil" do
      date = Metadata::Fields::DateField.new(bc: nil)
      expect(date.bc?).to be_falsey
    end
  end

  describe "human_readable" do
    it "uses FormatDisplayText to determine how to format display text" do
      date = Metadata::Fields::DateField.new(display_text: "display-text")
      expect(Metadata::Fields::DateField::FormatDisplayText).to receive(:format).with(date)
      date.human_readable
    end
  end

  describe "display_text" do
    it "returns the passed in display_text" do
      date = Metadata::Fields::DateField.new(display_text: "display-text")
      expect(date.display_text).to eq("display-text")
    end

    it "returns nil if there is nothing passed in for display-text" do
      date = Metadata::Fields::DateField.new({})
      expect(date.display_text).to eq(nil)
    end
  end

  describe "to_hash" do
    it "creates a hash for the api " do
      date = Metadata::Fields::DateField.new(year: "2010", month: "2", day: "1", bc: true, display_text: "display_text")
      expect(date.to_hash).to eq(
        "@type" => "MetadataDate",
        value: "display_text",
        iso8601: "-2010-02-01",
        year: "2010",
        month: "2",
        day: "1",
        bc: true,
        displayText: "display_text"
      )
    end
  end

  describe "to_params" do
    it "stringifys the keys correctly" do
      date = Metadata::Fields::DateField.new(year: "2010", month: "2", day: "1", bc: true, display_text: "display_text")
      expect(date.to_params).to eq(
        "bc" => true,
        "day" => "1",
        "year" => "2010",
        "month" => "2",
        "display_text" => "display_text"
      )
    end

    it "matches Postgres' order for the keys" do
      date = Metadata::Fields::DateField.new(year: "2010", month: "2", day: "1", bc: true, display_text: "display_text")
      keys = ["bc", "day", "year", "month", "display_text"]
      expect(date.to_params.keys).to eq(keys)
    end
  end

  context "validations" do
    describe "year" do
      it "does not allow nil" do
        date = Metadata::Fields::DateField.new(year: nil)
        expect(date).to have(1).errors_on(:year)
      end

      it "requires it to be an integer " do
        date = Metadata::Fields::DateField.new(year: "a")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow year 0" do
        date = Metadata::Fields::DateField.new(year: "0")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow negative numbers" do
        date = Metadata::Fields::DateField.new(year: "-100")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow numbers greater than 9999" do
        date = Metadata::Fields::DateField.new(year: "10000")
        expect(date).to have(1).errors_on(:year)
      end
    end

    describe "month" do
      it "allows nil" do
        date = Metadata::Fields::DateField.new(month: nil)
        expect(date).to have(0).errors_on(:month)
      end

      it "requires it to be an integer " do
        date = Metadata::Fields::DateField.new(month: "a")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow year 0" do
        date = Metadata::Fields::DateField.new(month: "0")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow negative numbers" do
        date = Metadata::Fields::DateField.new(month: "-100")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow numbers greater than 12" do
        date = Metadata::Fields::DateField.new(month: "13")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow a blank month when day is present" do
        date = Metadata::Fields::DateField.new(month: nil, day: "1")
        expect(date).to have(1).errors_on(:month)
      end
    end

    describe "day" do
      it "allows nil" do
        date = Metadata::Fields::DateField.new(day: nil)
        expect(date).to have(0).errors_on(:day)
      end

      it "requires it to be an integer " do
        date = Metadata::Fields::DateField.new(day: "a")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow year 0" do
        date = Metadata::Fields::DateField.new(day: "0")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow negative numbers" do
        date = Metadata::Fields::DateField.new(day: "-100")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow numbers greater than 31" do
        date = Metadata::Fields::DateField.new(month: "32")
        expect(date).to have(1).errors_on(:month)
      end
    end
  end

  describe "parse" do
    it "handles leading string literal character" do
      date = Metadata::Fields::DateField.parse("'2001/01/01:display this instead")
      expect(date.year).to eq("2001")
      expect(date.month).to eq("1")
      expect(date.day).to eq("1")
      expect(date.bc).to eq(false)
      expect(date.display_text).to eq("display this instead")
    end

    context "with display text" do
      it "gets display text if given with a :" do
        date = Metadata::Fields::DateField.parse("2001/01/01:display this instead")
        expect(date.display_text).to eq("display this instead")
      end

      it "doesn't error when given a : with no following text" do
        date = Metadata::Fields::DateField.parse("2001/01/01:")
        expect(date.display_text).to eq(nil)
      end
    end

    context "bc dates" do
      it "sets date to a BC year if year < 0" do
        date = Metadata::Fields::DateField.parse("-200/01/01")
        expect(date.year).to eq("200")
        expect(date.bc).to eq(true)
      end

      it "sets date to an AD year if year > 0" do
        date = Metadata::Fields::DateField.parse("1000/01/01")
        expect(date.year).to eq("1000")
        expect(date.bc).to eq(false)
      end
    end

    context "years" do
      it "does not allow year 0000" do
        date = Metadata::Fields::DateField.parse("0000/01/01")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow year 000" do
        date = Metadata::Fields::DateField.parse("000/01/01")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow year 00" do
        date = Metadata::Fields::DateField.parse("00/01/01")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow year 0" do
        date = Metadata::Fields::DateField.parse("0/01/01")
        expect(date).to have(1).errors_on(:year)
      end

      it "returns nil if given an empty string" do
        date = Metadata::Fields::DateField.parse("")
        expect(date).to eq(nil)
      end

      it "requires year" do
        date = Metadata::Fields::DateField.parse("/01")
        expect(date).to have(1).errors_on(:year)
      end

      it "sets correct year with only 1 digit" do
        date = Metadata::Fields::DateField.parse("1/01/01")
        expect(date.year).to eq("1")
      end

      it "sets correct year with only 2 digits" do
        date = Metadata::Fields::DateField.parse("10/01/01")
        expect(date.year).to eq("10")
      end

      it "sets correct year with only three digits" do
        date = Metadata::Fields::DateField.parse("100/01/01")
        expect(date.year).to eq("100")
      end

      it "sets correct year when given no month or day" do
        date = Metadata::Fields::DateField.parse("100")
        expect(date.year).to eq("100")
      end
    end

    context "months" do
      it "sets correct month when given yyyy/mm/dd" do
        date = Metadata::Fields::DateField.parse("2000/05/10")
        expect(date.month).to eq("5")
      end

      it "sets correct month when given no day" do
        date = Metadata::Fields::DateField.parse("100/10")
        expect(date.month).to eq("10")
      end

      it "does not set a month if only given year" do
        date = Metadata::Fields::DateField.parse("100")
        expect(date.month).to eq(nil)
      end
    end

    describe "days" do
      it "sets correct day when given yyyy/mm/dd" do
        date = Metadata::Fields::DateField.parse("2000/05/10")
        expect(date.day).to eq("10")
      end

      it "does not set a day if only given y/m" do
        date = Metadata::Fields::DateField.parse("100/3")
        expect(date.day).to eq(nil)
      end

      it "does not set a day if only given year" do
        date = Metadata::Fields::DateField.parse("100")
        expect(date.day).to eq(nil)
      end
    end
  end

  describe "can_parse?" do
    it "handles valid date without leading zeros" do
      result = Metadata::Fields::DateField.can_parse?("1995/2/3")
      expect(result).to eq(true)
    end

    it "accepts small years" do
      result = Metadata::Fields::DateField.can_parse?("9/2/3")
      expect(result).to eq(true)
    end

    it "accepts date with no day" do
      result = Metadata::Fields::DateField.can_parse?("9/2")
      expect(result).to eq(true)
    end

    it "accepts date with no month or day" do
      result = Metadata::Fields::DateField.can_parse?("1995")
      expect(result).to eq(true)
    end

    context "with display text" do
      it "considers date with display text parseable" do
        result = Metadata::Fields::DateField.can_parse?("1995/2/3:display text")
        expect(result).to eq(true)
      end
    end

    context "bc dates" do
      it "treats BC date as parseable" do
        result = Metadata::Fields::DateField.can_parse?("-200/01/01")
        expect(result).to eq(true)
      end
    end

    context "format validation" do
      it "does not allow more slashes after date" do
        result = Metadata::Fields::DateField.can_parse?("2000/01/01/13")
        expect(result).to eq(false)
      end

      describe "years" do
        it "does not allow special characters" do
          result = Metadata::Fields::DateField.can_parse?("200.0/01/01")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("200e/01/01")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("2000+/01/01")
          expect(result).to eq(false)
        end

        it "does not allow more than 4 digits" do
          result = Metadata::Fields::DateField.can_parse?("10001/01/01")
          expect(result).to eq(false)
        end
      end

      describe "months" do
        it "does not allow special characters" do
          result = Metadata::Fields::DateField.can_parse?("2000/0.1/01")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("200/e1/01")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("2000/1+/01")
          expect(result).to eq(false)
        end

        it "does not allow more than 2 digits" do
          result = Metadata::Fields::DateField.can_parse?("2000/012/01")
          expect(result).to eq(false)
        end
      end

      describe "days" do
        it "does not allow special characters" do
          result = Metadata::Fields::DateField.can_parse?("2000/01/0.1")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("2000/01/e1")
          expect(result).to eq(false)
          result = Metadata::Fields::DateField.can_parse?("2000/01/1+")
          expect(result).to eq(false)
        end

        it "does not allow more than 2 digits" do
          result = Metadata::Fields::DateField.can_parse?("2000/01/012")
          expect(result).to eq(false)
        end
      end
    end
  end

  describe "to_string" do
    it "adds :display_text when available" do
      date = Metadata::Fields::DateField.new(year: "2001", month: nil, day: nil, bc: false, display_text: "display this instead")
      expect(date.to_string).to eq("2001:display this instead")
    end

    it "adds the year when available" do
      date = Metadata::Fields::DateField.new(year: "2001", month: nil, day: nil, bc: false, display_text: nil)
      expect(date.to_string).to eq("2001")
    end

    it "adds the month when available" do
      date = Metadata::Fields::DateField.new(year: "2001", month: "01", day: nil, bc: false, display_text: nil)
      expect(date.to_string).to eq("2001/01")
    end

    it "adds the day when available" do
      date = Metadata::Fields::DateField.new(year: "2001", month: "01", day: "02", bc: false, display_text: nil)
      expect(date.to_string).to eq("2001/01/02")
    end

    it "adds - to bc dates when available" do
      date = Metadata::Fields::DateField.new(year: "2001", month: nil, day: nil, bc: true, display_text: nil)
      expect(date.to_string).to eq("-2001")
    end
  end
end
