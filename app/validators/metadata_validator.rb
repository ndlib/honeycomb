class MetadataValidator < ActiveModel::Validator
  attr_reader :record

  def validate(record)
    @record = record
    @configuration = load_configuration
    validates_presence
    validate_dates
  end

  private

  def validates_presence
    configuration.fields.each do |field|
      value = record.field(field.name)
      if not_present?(field, value)
        record.errors[field.name] << "is required"
      end
    end
  end

  def validate_dates
    configuration.fields.each do |field|
      value = record.field(field.name)
      if date_field?(field, value)
        test_date(field, value)
      end
    end
  end

  def configuration
    @configuration
  end

  def not_present?(field, value)
    field.required && (value.nil? || value.empty?)
  end

  def date_field?(field, value)
    field.type == :date && value.present?
  end

  def test_date(field, value)
    date = value.first
    field_name = field.name
    if !date.valid?
      date.errors.full_messages.each do |key, msg|
        record.errors[key] << msg
      end
    end

    add_generic_date_errors(field_name, date)
  end

  def add_generic_date_errors(field, date)
    if record.errors[field] && !date.to_date
      record.errors[field] << "Invalid Date"
    end
  end

  def load_configuration
    CollectionConfigurationQuery.new(@record.item.collection).find
  end
end
