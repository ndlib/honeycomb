# Validator to make sure submitted date is correctly formatted
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @error_message = nil
    record.errors[attribute] << (@error_message || "Invalid date") unless date_valid?(value)
  end

  private

  def date_valid?(value)
    date_data = { display_text: nil, value: value }
    return true if value.nil?
    begin
      MetadataDate.new(date_data)
    rescue MetadataDate::ParseError => e
      @error_message = e.message
      false
    rescue ArgumentError
      false
    end
  end
end
