require "rails_helper"

RSpec.describe MetadataDate do
  describe :year do
    it "passes the value of the year field " do
      date = MetadataDate.new(year: "year")
      expect(date.year).to eq("year")
    end

    it "returns nil if there is nothing passed in for year" do
      date = MetadataDate.new({})
      expect(date.year).to eq(nil)
    end
  end

  describe :month do
    it "passes the value of the month field " do
      date = MetadataDate.new(month: "month")
      expect(date.month).to eq("month")
    end

    it "returns nil if there is nothing passed in for month" do
      date = MetadataDate.new({})
      expect(date.month).to eq(nil)
    end
  end

  describe :day do
    it "passes the value of the day field " do
      date = MetadataDate.new(year: "day")
      expect(date.year).to eq("day")
    end

    it "returns nil if there is nothing passed in for day" do
      date = MetadataDate.new({})
      expect(date.day).to eq(nil)
    end
  end

  describe :bc? do
    it "is true when the date is BC" do
      date = MetadataDate.new(bc: true)
      expect(date.bc?).to be_truthy
    end

    it "is false when the date is AD" do
      date = MetadataDate.new(bc: false)
      expect(date.bc?).to be_falsey
    end
  end

  describe :human_readable do
    it "uses FormatDisplayText to determine how to format display text" do
      date = MetadataDate.new(display_text: "display-text")
      expect(MetadataDate::FormatDisplayText).to receive(:format).with(date)
      date.human_readable
    end
  end

  describe :display_text do
    it "returns the passed in display_text" do
      date = MetadataDate.new(display_text: "display-text")
      expect(date.display_text).to eq("display-text")
    end

    it "returns nil if there is nothing passed in for display-text" do
      date = MetadataDate.new({})
      expect(date.display_text).to eq(nil)
    end
  end

  context :validations do
    describe :year do
      it "does not allow nil" do
        date = MetadataDate.new(year: nil)
        expect(date).to have(1).errors_on(:year)
      end

      it "requires it to be an integer " do
        date = MetadataDate.new(year: "a")
        expect(date).to have(1).errors_on(:year)
      end

      it "does allow year 0" do
        date = MetadataDate.new(year: "0")
        expect(date).to have(0).errors_on(:year)
      end

      it "does not allow negative numbers" do
        date = MetadataDate.new(year: "-100")
        expect(date).to have(1).errors_on(:year)
      end

      it "does not allow numbers greater than 9999" do
        date = MetadataDate.new(year: "10000")
        expect(date).to have(1).errors_on(:year)
      end
    end

    describe :month do
      it "allows nil" do
        date = MetadataDate.new(month: nil)
        expect(date).to have(0).errors_on(:month)
      end

      it "requires it to be an integer " do
        date = MetadataDate.new(month: "a")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow year 0" do
        date = MetadataDate.new(month: "0")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow negative numbers" do
        date = MetadataDate.new(month: "-100")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow numbers greater than 12" do
        date = MetadataDate.new(month: "13")
        expect(date).to have(1).errors_on(:month)
      end

      it "does not allow a blank month when day is present" do
        date = MetadataDate.new(month: nil, day: "1")
        expect(date).to have(1).errors_on(:month)
      end
    end

    describe :day do
      it "allows nil" do
        date = MetadataDate.new(day: nil)
        expect(date).to have(0).errors_on(:day)
      end

      it "requires it to be an integer " do
        date = MetadataDate.new(day: "a")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow year 0" do
        date = MetadataDate.new(day: "0")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow negative numbers" do
        date = MetadataDate.new(day: "-100")
        expect(date).to have(1).errors_on(:day)
      end

      it "does not allow numbers greater than 31" do
        date = MetadataDate.new(month: "32")
        expect(date).to have(1).errors_on(:month)
      end
    end
  end
end
