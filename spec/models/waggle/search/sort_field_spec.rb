require "rails_helper"

RSpec.describe Waggle::Search::SortField do
  let(:sort_config) { instance_double(Metadata::Configuration::Sort, name: "creatorasc", label: "Creator", active: false, order: 3) }
  subject { described_class.new(name: "Name", value: "nameasc", active: false, order: 3) }

  describe "name" do
    it "is the name" do
      expect(subject.name).to eq("Name")
    end
  end

  describe "value" do
    it "is the value" do
      expect(subject.value).to eq("nameasc")
    end
  end

  describe "order" do
    it "is the order" do
      expect(subject.order).to eq(3)
    end
  end

  describe "self.from_config" do
    subject { described_class.from_config(sort_config) }

    it "creates an instance with the expected values" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq("Creator")
      expect(subject.value).to eq("creatorasc")
    end
  end

  describe "active" do
    it "is the expected value" do
      expect(subject.active).to eq(sort_config.active)
    end

    it "is assumed true if not given in params" do
      subject = described_class.new(name: "Name", value: "nameasc")
      expect(subject.active).to eq(true)
    end
  end
end
