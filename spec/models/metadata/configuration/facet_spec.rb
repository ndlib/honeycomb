require "rails_helper"

RSpec.describe Metadata::Configuration::Facet do
  let(:field) { instance_double(Metadata::Configuration::Field, name: :my_field, label: "Default Label") }
  let(:data) { { name: :my_facet, field_name: :my_field, field: field, label: "Custom Label", active: false, limit: 462 } }
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

  describe "limit" do
    it "is the expected value" do
      expect(subject.limit).to eq(data.fetch(:limit))
    end

    it "is assumed nil if not given in params" do
      data.delete(:limit)
      expect(subject.limit).to eq(nil)
    end
  end
end
