class MetadataDate
  class ConvertToIsoDate
    attr_reader :metadata_date

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def convert
      return false if !metadata_date.valid? || !metadata_date.to_date

      date = format_date
      format_bc(date)
    end

    private

    def format_date
      if values.present?
        values.join("-")
      else
        raise "Invalid metadata date. I expect this state to be unreachable so there is an error somewhere."
      end
    end

    def format_bc(date)
      if metadata_date.bc?
        date = "-#{date}"
      end
      date
    end

    def values
      @values ||= [metadata_date.year, metadata_date.month, metadata_date.day].compact
    end
  end
end
