module Metadata
  class Fields
    class DateField
      include ActiveModel::Validations

      attr_reader :year, :month, :day, :bc, :display_text

      validates :year, numericality: { only_integer: true, allow_blank: false, greater_than: 0, less_than_or_equal_to: 9999 }
      validates :month, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
      validates :day, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
      validates :month, presence: true, if: :month_required?

      def self.from_hash(hash)
        new(**hash.symbolize_keys)
      end

      def initialize(year: nil, month: nil, day: nil, bc: nil, display_text: nil)
        @year = parse_value(year)
        @month = parse_value(month)
        @day = parse_value(day)
        @bc = bc
        @display_text = parse_value(display_text)
      end

      def bc?
        bc.to_s == "true"
      end

      def human_readable
        @human_readable ||= FormatDisplayText.format(self)
      end

      def iso8601
        @iso ||= ConvertToIsoDate.new(self).convert
      end

      def to_date
        @date ||= ConvertToRubyDate.new(self).convert
      end

      def value
        to_params
      end

      def to_hash
        {
          "@type" => "MetadataDate",
          value: human_readable,
          iso8601: iso8601,
          year: year,
          month: month,
          day: day,
          bc: bc,
          displayText: display_text,
        }
      end

      def to_params
        {
          bc: bc,
          day: day,
          year: year,
          month: month,
          display_text: display_text,
        }.stringify_keys
      end

      def to_string # rubocop:disable Metrics/AbcSize
        result = ""
        result << "-" if bc?
        result << year.to_s.rjust(4, "0") if year.present?
        result << "/#{month.to_s.rjust(2, '0')}" if month.present?
        result << "/#{day.to_s.rjust(2, '0')}" if day.present?
        result << ":#{display_text}" if display_text.present?
        result
      end

      def self.can_parse?(string)
        date_and_display = string.split(":")
        if !date_and_display.empty?
          date_array = date_and_display[0].split("/")
          (
            # Validate year is 1-4 digits (with optional - for BC)
            /^-?\d{1,4}$/.match(date_array[0].tr("'", "")) && (
              date_array.length < 2 || /^\d{1,2}$/.match(date_array[1]) # validate no month or 1-2 digits
            ) && (
              date_array.length < 3 || /^\d{1,2}$/.match(date_array[2]) # validate no day or 1-2 digits
            ) && date_array.length < 4 # validate nothing in string after day
          ).present?
        else
          false
        end
      end

      def self.parse(string)
        date_and_display = string.split(":")
        if !date_and_display.empty?
          display_text = date_and_display.fetch(1, nil)
          date = parse_date(value: date_and_display[0])
          new(year: date[:year].abs,
              month: date[:month],
              day: date[:day],
              bc: (date[:year] < 0),
              display_text: display_text)
        end
      end

      # Parses a date string into hash. Expects format y/m/d
      def self.parse_date(value:)
        date_array = value.split("/")
        {
          year: date_array.length >= 1 ? date_array[0].tr("'", "").to_i : nil,
          month: date_array.length > 1 ? date_array[1].to_i : nil,
          day: date_array.length > 2 ? date_array[2].to_i : nil
        }
      end
      private_class_method :parse_date

      private

      def parse_value(value)
        value ? value.to_s.strip : nil
      end

      def month_required?
        day.present?
      end
    end
  end
end
