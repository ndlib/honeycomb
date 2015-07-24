# Validator to make sure submitted date is correctly formatted
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if !value

    date = MetadataDate.new(value.symbolize_keys)
    if !date.valid?
      date.errors.full_messages.each do |msg|
        record.errors[attribute] << msg
      end
    end
    # this is to catch an additional errors from date formatting such as but not limited to
    # invalid days for a month.
    if record.errors[attribute].empty? && !date.to_date
      record.errors[attribute] << "Invalid Date"
    end
  end
end
