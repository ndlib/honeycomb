class MetadataDate
  include ActiveModel::Validations

  attr_reader :year, :month, :day, :bc, :display_text

  validates :year, numericality: { only_integer: true, allow_nil: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999 }
  validates :month, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :day, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :month, presence: true, if: :month_required?

  def initialize(year: nil, month: nil, day: nil, bc: nil, display_text: nil)
    @year = parse_value(year)
    @month = parse_value(month)
    @day = parse_value(day)
    @bc = bc
    @display_text = parse_value(display_text)
  end

  def bc?
    bc.present?
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

  private

  def parse_value(value)
    value ? value.to_s.strip : nil
  end

  def month_required?
    day.present?
  end
end
