require "rails_helper"

RSpec.describe Metadata::Configuration do
  let(:field_data) do
    [
      { name: "string_field", type: "string", label: "String", default_form_field: true, optional_form_field: false, order: 0 },
      { name: "date_field", type: "date", label: "Date", default_form_field: true, optional_form_field: false, order: 0 },
    ]
  end
  let(:facet_data) do
    [
      { name: "string_field_facet", field_name: "string_field", active: true, order: 0 },
      { name: "string_field_facet_2", field_name: "string_field", active: true, label: "Custom Label", order: 0 },
    ]
  end
  let(:sort_data) do
    [
      { name: "string_field_sort", field_name: "string_field", direction: "asc", order: 0 },
      { name: "string_field_sort_2", field_name: "string_field", direction: "desc", label: "Descending Label", order: 0 },
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
      expect(described_class::Sort).to receive(:new).with(sort_data[0].merge(active: true, field: kind_of(described_class::Field))).and_call_original
      expect(described_class::Sort).to receive(:new).with(sort_data[1].merge(active: true, field: kind_of(described_class::Field))).and_call_original
      expect(subject).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(described_class::Sort)
    end
  end

  describe "#save_field" do
    let(:field) { double(described_class::Field, valid?: true, update: true, to_hash: { name: "name" }) }
    let(:update_values) { { label: "label", order: 1 } }

    before(:each) do
      allow(data).to receive(:save).and_return(true)
      allow(subject).to receive(:field).and_return(field)
    end

    it "retrieves the field from the name passed in" do
      expect(subject).to receive(:field).with(:field_name).and_return(field)
      subject.save_field(:field_name, update_values)
    end

    it "creates a new field if the field is not found" do
      allow(subject).to receive(:field).with(:field_name).and_return(nil)
      allow(described_class::Field).to receive(:new).and_return(field)
      expect(described_class::Field).to receive(:new).with(update_values).and_return(field)
      subject.save_field(:field_name, update_values)
    end

    it "calls update on the field when it already exists" do
      expect(field).to receive(:update).with(update_values).and_return(true)
      subject.save_field(:field_name, update_values)
    end

    it "returns false if the update of the field fails" do
      allow(field).to receive(:update).with(update_values).and_return(false)
      allow(field).to receive(:valid?).and_return(false)
      expect(subject.save_field(:field_name, update_values)).to be(false)
    end

    it "updates the metadata configuration " do
      expect(data).to receive("metadata=")
      subject.save_field(:field_name, update_values)
    end

    it "saves the metadata configuration" do
      expect(data).to receive("save").and_return(true)
      subject.save_field(:field_name, update_values)
    end

    it "returns the field if the metadata has been saved successfully" do
      allow(data).to receive("save").and_return(true)
      expect(subject.save_field(:field_name, update_values)).to eq(field)
    end

    it "returns false if the metadata has been saved successfully" do
      allow(data).to receive("save").and_return(false)
      expect(subject.save_field(:field_name, update_values)).to be(false)
    end
  end

  describe "#save_facet" do
    let(:facet) { double(described_class::Facet, valid?: true, update: true, to_hash: { name: "name" }) }
    let(:update_values) { { label: "label", order: 1 } }

    before(:each) do
      allow(data).to receive(:save).and_return(true)
      allow(subject).to receive(:facet).and_return(facet)
    end

    it "retrieves the facet from the name passed in" do
      expect(subject).to receive(:facet).with(:facet_name).and_return(facet)
      subject.save_facet(:facet_name, update_values)
    end

    it "creates a new facet if the facet is not found" do
      allow(subject).to receive(:facet).with(:facet_name).and_return(nil)
      allow(described_class::Facet).to receive(:new).and_return(facet)
      expect(described_class::Facet).to receive(:new).with(update_values).and_return(facet)
      subject.save_facet(:facet_name, update_values)
    end

    it "calls update on the facet when it already exists" do
      expect(facet).to receive(:update).with(update_values).and_return(true)
      subject.save_facet(:facet_name, update_values)
    end

    it "returns false if the update of the facet fails" do
      allow(facet).to receive(:update).with(update_values).and_return(false)
      allow(facet).to receive(:valid?).and_return(false)
      expect(subject.save_facet(:facet_name, update_values)).to be(false)
    end

    it "updates the facets configuration " do
      expect(data).to receive("facets=")
      subject.save_facet(:facet_name, update_values)
    end

    it "saves the facets configuration" do
      expect(data).to receive("save").and_return(true)
      subject.save_facet(:facet_name, update_values)
    end

    it "returns the facet if the metadata has been saved successfully" do
      allow(data).to receive("save").and_return(true)
      expect(subject.save_facet(:facet_name, update_values)).to eq(facet)
    end

    it "returns false if the metadata has been saved successfully" do
      allow(data).to receive("save").and_return(false)
      expect(subject.save_facet(:facet_name, update_values)).to be(false)
    end
  end

  describe "#save_sort" do
    let(:sort) { double(described_class::Sort, valid?: true, update: true, to_hash: { name: "name" }) }
    let(:update_values) { { label: "label", order: 1 } }

    before(:each) do
      allow(data).to receive(:save).and_return(true)
      allow(subject).to receive(:sort).and_return(sort)
    end

    it "retrieves the sort from the name passed in" do
      expect(subject).to receive(:sort).with(:sort_name).and_return(sort)
      subject.save_sort(:sort_name, update_values)
    end

    it "creates a new sort if the sort is not found" do
      allow(subject).to receive(:sort).with(:sort_name).and_return(nil)
      allow(described_class::Sort).to receive(:new).and_return(sort)
      expect(described_class::Sort).to receive(:new).with(update_values).and_return(sort)
      subject.save_sort(:sort_name, update_values)
    end

    it "calls update on the sort when it already exists" do
      expect(sort).to receive(:update).with(update_values).and_return(true)
      subject.save_sort(:sort_name, update_values)
    end

    it "returns false if the update of the sort fails" do
      allow(sort).to receive(:update).with(update_values).and_return(false)
      allow(sort).to receive(:valid?).and_return(false)
      expect(subject.save_sort(:sort_name, update_values)).to be(false)
    end

    it "updates the sorts configuration " do
      expect(data).to receive("sorts=")
      subject.save_sort(:sort_name, update_values)
    end

    it "saves the sorts configuration" do
      expect(data).to receive("save").and_return(true)
      subject.save_sort(:sort_name, update_values)
    end

    it "returns the sort if the metadata has been saved successfully" do
      allow(data).to receive("save").and_return(true)
      expect(subject.save_sort(:sort_name, update_values)).to eq(sort)
    end

    it "returns false if the metadata fails to save successfully" do
      allow(data).to receive("save").and_return(false)
      expect(subject.save_sort(:sort_name, update_values)).to be(false)
    end
  end
end
