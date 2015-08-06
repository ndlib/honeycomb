require "rails_helper"

RSpec.describe Waggle::Adapters::Sunspot::Adapters::ItemDataAccessor do
  let(:clazz) { class_double(Waggle::Item) }
  subject { described_class.new(clazz) }

  it "implements load" do
    expect(clazz).to receive(:load).with("id").and_return("loaded")
    expect(subject.load("id")).to eq("loaded")
  end
end
