class MetadataDate
  attr_reader :date_data, :parsed_date, :date, :display_text

  class ParseError < Exception
  end

  def initialize(data)
    if !data[:value]
      raise ParseError.new("No date value submitted")
    end

    @date_data = data
    parse_date
    setup_date
  end

  def bc?
    (year < 0)
  end

  def human_readable
    @human_readable ||= FormatDisplayText.format(self)
  end

  def display_text
    @date_data[:display_text]
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
    if !@parsed_date ||= date_data[:value].scan(/^([-]?\d{1,4})[-]?(\d{1,2})?[-]?(\d{1,2})?$/).first
      raise ParseError.new("Unable to parse date")
    end
  end

  def setup_date
    if day
      @date = Date.new(year, month, day)
    elsif month
      @date = Date.new(year, month)
    elsif year
      @date = Date.new(year)
    else
      raise ParseError.new("Unable to setup date from parsed data")
    end
  end

  class FormatDisplayText
    attr_reader :metadata_date

    def self.format(metadata_date)
      new(metadata_date).format
    end

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def format
      if metadata_date.display_text
        metadata_date.display_text
      else
        format_date
      end
    end

    private

    def date_format
      if metadata_date.day
        :year_month_day
      elsif metadata_date.month
        :year_month
      else
        :year_only
      end
    end

    def format_date
      date = I18n.localize(metadata_date.date, format: date_format)
      date = fix_bc_date(date)

      date
    end

    def fix_bc_date(date)
      if metadata_date.bc?
        date += " BC"
        date.gsub!(metadata_date.year.to_s, metadata_date.year.abs.to_s)
      end
      date
    end
  end
end
