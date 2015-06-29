class MetadataDate
  attr_reader :date_data, :parsed_date, :date, :display_text

  class ParseError < Exception
  end

  def initialize(data)
    @date_data = data
    parse_date
    setup_date
  end

  def bc?
    (year < 0)
  end

  def display_text
    @display_text ||= FormatDisplayText.format(self)
  end

  def year
    @year ||= parsed_date[0] ? parsed_date[0].to_i : nil
  end

  def month
    @month ||= parsed_date[1] ? parsed_date[1].to_i : nil
  end

  def day
    @day ||= parsed_date[2] ? parsed_date[2].to_i : nil
  end

  private

  def parse_date
    if !@parsed_date ||= date_data[:value].scan(/^([-]?\d{1,4})[-]?(\d{1,2})?[-]?(\d{1,2})?/).first
      raise ParseError.new("unable to parse date")
      return
    end
  end

  def setup_date
    if (day)
      @date = Date.new(year, month, day)
    elsif (month)
      @date = Date.new(year, month)
    elsif (year)
      @date = Date.new(year)
    else
      raise ParseError.new("unable to setup date from parsed data")
    end
  end

  class FormatDisplayText
    attr_reader :date

    def self.format(date)
      new(date).format
    end

    def initialize(date)
      @date = date
    end

    def format
      if date.display_text
        date.display_text
      else
        date.to_s + "BC"
      end
    end

    private

    
  end
end
