require "rails_helper"

RSpec.describe Metadata::ConfigurationInputCleaner do
  let(:data) { {} }

  subject { described_class.call(data) }

  it "converts string keys data to symbols" do
    data["field"] = "data"
    expect(subject).to eq(field: "data")
  end

  it "downcases labels into the name " do
    data[:label] = "Name"
    expect(subject).to eq(label: "Name", name: "name")
  end

  it "creates a name out of the label" do
    data[:label] = "Name"
    expect(subject).to eq(label: "Name", name: "name")
  end

  it "underscores spaces in the label to names" do
    data[:label] = "na me"
    expect(subject).to eq(label: "na me", name: "na_me")
  end

  [:required, :default_form_field, :optional_form_field, :active].each do |key|
    it "converts string \"true\" types for #{key} to true" do
      data[key] = "true"
      expect(subject).to eq(key => true)
    end

    it "converts string \"false\" types for #{key} to false" do
      data[key] = "false"
      expect(subject).to eq(key => false)
    end

    it "converts string \"\" types for #{key} to false" do
      data[key] = ""
      expect(subject).to eq(key => false)
    end

    it "retuns true for types #{key} to true" do
      data[key] = true
      expect(subject).to eq(key => true)
    end

    it "retuns false for types #{key} to false" do
      data[key] = false
      expect(subject).to eq(key => false)
    end
  end

  [:order, :boost].each do |key|
    it "retains the value if #{key} is already an integer" do
      data[key] = 10
      expect(subject).to eq(key => 10)
    end

    it "converts string \"integer\" types for #{key} to int" do
      data[key] = "1"
      expect(subject).to eq(key => 1)
    end

    it "does not convert the empty string for #{key}" do
      data[key] = ""
      expect(subject).to eq(key => "")
    end

    it "does not convert a non numeric string for #{key}" do
      data[key] = "1 - This is not a number"
      expect(subject).to eq(key => "1 - This is not a number")
    end

    it "does not convert #{key} if it's not a string" do
      data[key] = { k: 1 }
      expect(subject).to eq(key => { k: 1 })
    end
  end
end
