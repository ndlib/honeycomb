require "rails_helper"

RSpec.describe Metadata::Configuration do
  let(:field_data) do
    [
      { name: "string_field", type: "string", label: "String", default_form_field: true, optional_form_field: false, order: true },
      { name: "date_field", type: "date", label: "Date", default_form_field: true, optional_form_field: false, order: true },
    ]
  end
  let(:facet_data) do
    [
      { name: "string_field_facet", field_name: "string_field" },
      { name: "string_field_facet_2", field_name: "string_field", label: "Custom Label" },
    ]
  end
  let(:sort_data) do
    [
      { name: "string_field_sort", field_name: "string_field", direction: "asc" },
      { name: "string_field_sort_2", field_name: "string_field", direction: "desc", label: "Descending Label" },
    ]
  end
  let(:data) do
    CollectionConfiguration.new(
      metadata: field_data,
      facets: facet_data,
      sorts: sort_data
    )
  end
  let(:instance) { described_class.new(data) }

  subject { instance }

  describe "field" do
    it "finds a field by its name" do
      field = subject.field(:string_field)
      expect(field).to be_kind_of(described_class::Field)
      expect(field.name).to eq(:string_field)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.field(:fake_field)).to be_nil
    end
  end

  describe "field?" do
    it "returns true for a field that exists" do
      expect(subject.field?(:string_field)).to eq(true)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.field?(:fake_field)).to eq(false)
    end
  end

  describe "field_names" do
    it "returns an array of field names" do
      expect(subject.field_names).to eq(data.metadata.map { |f| f["name"] })
    end
  end

  describe "field_labels" do
    it "returns an array of field labels" do
      expect(subject.field_labels).to eq(data.metadata.map { |f| f["label"] })
    end
  end

  describe "label" do
    it "finds a field by its label" do
      field = subject.label("String")
      expect(field).to be_kind_of(described_class::Field)
      expect(field.label).to eq("String")
    end

    it "returns nil if a label doesn't exist" do
      expect(subject.label("fake_field")).to be_nil
    end
  end

  describe "label?" do
    it "returns true for a field that exists" do
      expect(subject.label?("String")).to eq(true)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.label?("fake_field")).to eq(false)
    end
  end

  describe "fields" do
    subject { instance.fields }

    it "is an array of fields" do
      expect(described_class::Field).to receive(:new).with(field_data[0]).and_call_original
      expect(described_class::Field).to receive(:new).with(field_data[1]).and_call_original
      expect(subject).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(described_class::Field)
    end
  end

  describe "facet" do
    it "finds a facet by its name" do
      facet = subject.facet(:string_field_facet)
      expect(facet).to be_kind_of(described_class::Facet)
      expect(facet.name).to eq("string_field_facet")
    end

    it "returns nil if a facet doesn't exist" do
      expect(subject.facet(:fake_facet)).to be_nil
    end
  end

  describe "facet?" do
    it "returns true for a facet that exists" do
      expect(subject.facet?(:string_field_facet)).to eq(true)
    end

    it "returns nil if a facet doesn't exist" do
      expect(subject.facet?(:fake_facet)).to eq(false)
    end
  end

  describe "facets" do
    subject { instance.facets }

    it "is an array of facets" do
      expect(described_class::Facet).to receive(:new).with(facet_data[0].merge(field: kind_of(described_class::Field))).and_call_original
      expect(described_class::Facet).to receive(:new).with(facet_data[1].merge(field: kind_of(described_class::Field))).and_call_original
      expect(subject).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(described_class::Facet)
    end
  end

  describe "sort" do
    it "finds a sort by its name" do
      sort = subject.sort(:string_field_sort)
      expect(sort).to be_kind_of(described_class::Sort)
      expect(sort.name).to eq("string_field_sort")
    end

    it "returns nil if a sort doesn't exist" do
      expect(subject.sort(:fake_sort)).to be_nil
    end
  end

  describe "sorts" do
    subject { instance.sorts }

    it "is an array of sorts" do
      expect(described_class::Sort).to receive(:new).with(sort_data[0].merge(field: kind_of(described_class::Field))).and_call_original
      expect(described_class::Sort).to receive(:new).with(sort_data[1].merge(field: kind_of(described_class::Field))).and_call_original
      expect(subject).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(described_class::Sort)
    end
  end
end
