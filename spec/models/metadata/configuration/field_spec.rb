require "rails_helper"

RSpec.describe Metadata::Configuration::Field do
  let(:data) do
    {
      name: :string_field,
      active: false,
      type: :string,
      label: "String",
      placeholder: "placeholder",
      help: "help",
      default_form_field: true,
      optional_form_field: false,
      fieldSearch: false,
      order: 1,
      immutable: []
    }
  end

  subject { described_class.new(data) }

  describe "name" do
    it "is the expected value" do
      expect(subject.name).to eq(data[:name])
    end
  end

  describe "active" do
    it "is the expected value" do
      expect(subject.active).to eq(data[:active])
    end

    it "is true by default" do
      subject = described_class.new(data.except(:active))
      expect(subject.active).to eq(true)
    end
  end

  describe "immutable" do
    it "is the expected value" do
      expect(subject.immutable).to eq(data[:immutable])
    end

    it "returns name by default" do
      subject = described_class.new(data.except(:immutable))
      expect(subject.immutable).to eq(["name"])
    end
  end

  describe "type" do
    it "is the expected value" do
      expect(subject.type).to eq(data[:type])
    end

    described_class::TYPES.each do |type|
      it "can be '#{type}'" do
        data[:type] = type
        expect(subject.type).to eq(type)
      end
    end

    it "cannot be an unknown type" do
      data[:type] = :fake_type
      expect(subject.valid?).to eq(false)
    end
  end

  describe "label" do
    it "is the expected value" do
      expect(subject.label).to eq(data[:label])
    end
  end

  describe "placeholder" do
    it "is the expected value" do
      expect(subject.placeholder).to eq(data[:placeholder])
    end
  end

  describe "help" do
    it "is the expected value" do
      expect(subject.help).to eq(data[:help])
    end
  end

  describe "default_form_field" do
    it "is the expected value" do
      expect(subject.default_form_field).to eq(data[:default_form_field])
    end
  end

  describe "optional_form_field" do
    it "is the expected value" do
      expect(subject.optional_form_field).to eq(data[:optional_form_field])
    end
  end

  describe "order" do
    it "is the expected value" do
      expect(subject.order).to eq(data[:order])
    end
  end

  describe "boost" do
    it "defaults to 1" do
      expect(subject.boost).to eq(1)
    end

    it "can be set" do
      data[:boost] = 10
      expect(subject.boost).to eq(10)
    end
  end

  describe "to_json" do
    it "converts default_form_field to defaultFormField" do
      expect(subject.to_json).to include("defaultFormField")
      expect(subject.to_json).to_not include("default_form_field")
    end

    it "convertes the key option_form_field to optionalFormField" do
      expect(subject.to_json).to include("optionalFormField")
      expect(subject.to_json).to_not include("option_form_field")
    end
  end

  context "validations" do
    it "validates the presence of a name" do
      subject.name = nil
      expect(subject).to have(1).errors_on(:name)
    end

    it "validates the presence of type" do
      subject.type = nil
      expect(subject).to have(2).errors_on(:type)
    end

    it "validates the presence of label" do
      expect(subject.update(label: nil)).to be(false)
      expect(subject).to have(1).errors_on(:label)
    end

    it "validates the presence of order" do
      expect(subject.update(order: nil)).to be(false)
      expect(subject).to have_at_least(1).errors_on(:order)
      expect(subject.errors.messages[:order]).to include("can't be blank")
    end

    [:order, :boost].each do |key|
      it "validates #{key} is an integer" do
        expect(subject.update(key => nil)).to be(false)
        expect(subject).to have_at_least(1).errors_on(key)
        expect(subject.errors.messages[key]).to include("is not a number")
      end
    end
  end

  describe "update" do
    it "changes the values of the fields passed in" do
      subject.update(order: "new_order", label: "NAME!")
      expect(subject.order).to eq("new_order")
      expect(subject.label).to eq("NAME!")
    end

    it "errors if there are invalid keys in the field hash" do
      expect { subject.update(not_a_key: "value") }.to raise_error
    end

    it "returns true if it is a valid update" do
      expect(subject.update(label: "NAME!")).to be(true)
    end

    it "does not allow name to be changed" do
      subject.update(name: "new_name")
      expect(subject.name).to eq(:string_field)
    end

    it "converts a string type to symbol type" do
      subject.update(type: "html")
      expect(subject.type).to eq(:html)
    end

    it "converts json keys to ruby keys" do
      subject.update(defaultFormField: "true", optionalFormField: "false")
      expect(subject.default_form_field).to eq(true)
      expect(subject.optional_form_field).to eq(false)
    end

    it "converts string booleans to bools" do
      subject.update(multiple: "true", required: "false")
      expect(subject.multiple).to eq(true)
      expect(subject.required).to eq(false)
    end

    it "works with string keys" do
      subject.update("label" => "NAME!")
      expect(subject.label).to eq("NAME!")
    end

    it "does not update an immutable property" do
      data[:immutable] = ["type"]
      subject.update(type: "mynewtype")
      expect(subject.type).not_to eq(:mynewtype)
    end

    it "updates the immutable list" do
      subject.update(immutable: ["type"])
      expect(subject.immutable).to eq(["type"])
    end

    it "updates a field if the immutable list has been changed to remove that field" do
      data[:immutable] = ["type"]
      subject.update(type: "test", immutable: [])
      expect(subject.type).to eq(:test)
    end

    it "does not allow updating immutable to contain immutable" do
      subject.update(immutable: ["immutable", :immutable])
      expect(subject.immutable).to eq([])
    end
  end

  describe "to_hash" do
    it "converts the data to a hash." do
      expect(subject.to_hash).to eq(
        name: :string_field,
        active: false,
        type: :string,
        label: "String",
        multiple: false,
        required: false,
        default_form_field: true,
        optional_form_field: false,
        fieldSearch: false,
        order: 1,
        placeholder: "placeholder",
        help: "help",
        hidden: false,
        boost: 1,
        immutable: []
      )
    end
  end
end
