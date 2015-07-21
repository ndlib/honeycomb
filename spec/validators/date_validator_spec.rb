require "rails_helper"

describe DateValidator do
  let(:item) { Item.new }

  context "with valid date" do
    it "does not require a date string to be submitted" do
      item.date_created = nil
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows 1-4 digit years" do
      item.date_created = "1"
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows 1-2 digit months" do
      item.date_created = "1-06"
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows 1-2 digit days" do
      item.date_created = "1-06-30"
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows BC dates" do
      item.date_created = "-01-06"
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows dates with only a year" do
      item.date_created = "-01"
      expect(item).to have(0).errors_on(:date_created)
    end

    it "allows dates with only a month and a year" do
      item.date_created = "1-06"
      expect(item).to have(0).errors_on(:date_created)
    end
  end

  context "with invalid date" do
    it "does not allow alpha characters" do
      item.date_created = "e01-13"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Unable to parse date"
    end

    it "does not allow extra characters" do
      item.date_created = "+-01-13"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Unable to parse date"
    end

    it "does not allow more than 4 year digits" do
      item.date_created = "10000-12"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Invalid date"
    end

    it "does not allow more than 2 month digits" do
      item.date_created = "1000-120"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Invalid date"
    end

    it "verifies that the month is a valid month" do
      item.date_created = "1000-13"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Invalid date"
    end

    it "does not allow more than 2 day digits" do
      item.date_created = "1000-12-100"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Unable to parse date"
    end

    it "verifies that the day is a valid day" do
      item.date_created = "1000-12-32"
      expect(item).to have(1).errors_on(:date_created)
      expect(item.errors.messages[:date_created][0]).to eq "Invalid date"
    end
  end
end
