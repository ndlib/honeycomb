require "rails_helper"

RSpec.describe Metadata::Configuration::Sort do
  let(:field) { instance_double(Metadata::Configuration::Field, name: :my_field, label: "Default Label") }
  let(:data) { { name: :my_sort, field_name: :my_field, field: field, direction: :asc, label: "Custom Label", active: false, order: 3 } }
  let(:instance) { described_class.new(data) }
  subject { instance }

  describe "name" do
    it "is the expected value" do
      expect(subject.name).to eq(data.fetch(:name))
    end
  end

  describe "field" do
    it "is the expected value" do
      expect(subject.field).to eq(data.fetch(:field))
    end
  end

  describe "direction" do
    it "is the expected value" do
      expect(subject.direction).to eq(data.fetch(:direction))
    end
  end

  describe "field_name" do
    it "is the expected value" do
      expect(subject.field_name).to eq(data.fetch(:field_name))
    end
  end

  describe "label" do
    it "is the expected value" do
      expect(subject.label).to eq(data.fetch(:label))
    end

    it "defaults to the field label" do
      data[:label] = nil
      expect(subject.label).to eq(field.label)
    end
  end

  describe "active" do
    it "is the expected value" do
      expect(subject.active).to eq(data.fetch(:active))
    end

    it "is assumed true if not given in params" do
      data.delete(:active)
      expect(subject.active).to eq(true)
    end
  end

  describe "order" do
    it "is the expected value" do
      expect(subject.order).to eq(data.fetch(:order))
    end
  end

  describe "to_hash" do
    it "converts the data to a hash." do
      expect(subject.to_hash).to eq(
        name: :my_sort,
        field: field,
        field_name: :my_field,
        direction: :asc,
        label: "Custom Label",
        active: false,
        order: 3
      )
    end
  end

  describe "update" do
    it "changes the values of the attributes passed in" do
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
      expect(subject.name).to eq(:my_sort)
    end

    it "does not allow field to be changed" do
      subject.update(field: instance_double(Metadata::Configuration::Field, name: :new_field, label: "New Field Label"))
      expect(subject.field).to eq(field)
    end

    it "works with string keys" do
      subject.update("label" => "NAME!")
      expect(subject.label).to eq("NAME!")
    end
  end
end
