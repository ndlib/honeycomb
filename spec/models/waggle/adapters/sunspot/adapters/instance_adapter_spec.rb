require "rails_helper"

RSpec.describe Waggle::Adapters::Sunspot::Adapters::InstanceAdapter do
  let(:instance) { instance_double(Waggle::Item) }
  subject { described_class.new(instance) }

  it "implements id" do
    expect(instance).to receive(:id).and_return("id")
    expect(subject.id).to eq("id")
  end
end
