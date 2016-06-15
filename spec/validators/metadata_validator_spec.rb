
describe MetadataValidator do
  let(:metadata) { double(errors: errors) }
  let(:errors) { {} }
  let(:error) { double }
  let(:configuration) { double(Metadata::Configuration, fields: [field]) }

  let(:empty_value) { double(empty?: true, nil?: false) }
  let(:nil_value) { double(empty?: false, nil?: true) }
  let(:present_value) { double(empty?: false, nil?: false) }

  let(:date_value) { double(present?: true) }

  subject { MetadataValidator.new.validate(metadata) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:load_configuration).and_return(configuration)
  end

  context "required_field" do
    let(:field) { double(required: true, name: :field, type: :string) }

    it "adds an error if the field is empty?" do
      allow(metadata).to receive(:field).and_return(empty_value)
      expect(metadata.errors).to receive(:[]).with(field.name).and_return(error)
      expect(error).to receive("<<").with("is required")

      subject
    end

    it "adds an error if the field is nil?" do
      allow(metadata).to receive(:field).and_return(nil_value)
      expect(metadata.errors).to receive(:[]).with(field.name).and_return(error)
      expect(error).to receive("<<").with("is required")

      subject
    end

    it "does not add an error when the field has value " do
      allow(metadata).to receive(:field).and_return(present_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end
  end

  context "not required_field" do
    let(:field) { double(required: false, name: :field, type: :string) }

    it "adds an error if the field is empty?" do
      allow(metadata).to receive(:field).and_return(empty_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end

    it "adds an error if the field is nil?" do
      allow(metadata).to receive(:field).and_return(nil_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end

    it "does not add an error when the field has value " do
      allow(metadata).to receive(:field).and_return(present_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end
  end

  context "date field" do
    let(:field) { double(required: false, name: :field, type: :date) }
    let(:date_field) { double(Metadata::Fields::DateField, valid?: true, to_date: Time.now) }
    let(:date_errors) { double(full_messages: { field: "MESSAGE" }) }
    let(:date_result) { [date_field] }

    before(:each) do
      allow(metadata).to receive(:field).and_return(date_result)
    end

    it "uses the validation on the Metadata::Fields::DateField " do
      expect(date_field).to receive(:valid?).and_return(true)
      subject
    end

    it "passes the errors from date_field to " do
      allow(date_field).to receive(:erros).and_return(date_errors)
      expect(date_field).to receive(:valid?).and_return(false)
      expect(date_field).to receive(:errors).and_return(date_errors)
      expect(metadata.errors).to receive(:[]).with(:field).and_return(error).twice
      expect(error).to receive("<<").with("MESSAGE")

      subject
    end

    it "passes a generic errors to the errors" do
      allow(date_field).to receive(:erros).and_return(date_errors)
      expect(date_field).to receive(:valid?).and_return(true)
      expect(date_field).to receive(:to_date).and_return(nil)
      expect(metadata.errors).to receive(:[]).with(:field).and_return(error).twice
      expect(error).to receive("<<").with("Invalid Date")

      subject
    end
  end
end
