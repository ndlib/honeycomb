class MetadataDate
  class ConvertToRubyDate
    attr_reader :metadata_date

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def convert!
      return false if !metadata_date.valid?

      if values.present?
        Date.new(*values)
      else
        raise "Invalid metadata date. I expect this state to be unreachable so there is an error somewhere."
      end
    end

    def convert
      convert!
    rescue ArgumentError
      false
    end

    private

    def values
      @values ||= [metadata_date.year, metadata_date.month, metadata_date.day].compact.map(&:to_i)
    end
  end
end
