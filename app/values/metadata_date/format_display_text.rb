class MetadataDate
  class FormatDisplayText
    attr_reader :metadata_date

    def self.format(metadata_date)
      new(metadata_date).format
    end

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def format
      if metadata_date.display_text.present?
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
      if !date = metadata_date.to_date
        return ""
      end

      date = I18n.localize(date, format: date_format)
      date = add_bc_to_date(date)

      date
    end

    def add_bc_to_date(date)
      if metadata_date.bc?
        date += " BC"
      end
      date
    end
  end
end
