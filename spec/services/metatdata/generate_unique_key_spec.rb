require "rails_helper"

RSpec.describe Metadata::GenerateUniqueKey do
  subject { described_class.new }

  it "uses the SecureRandom to generate the unique key" do
    expect(SecureRandom).to receive(:uuid)
    subject.generate!
  end

  it "generates a 36 character sequence" do
    string = subject.generate!
    expect(string.length).to eq 36
  end

  it "generates a character string with a specific pattern" do
    string = subject.generate!
    expect(string).to match(/.{8}-.{4}-.{4}-.{4}-.{12}/)
  end

  describe "#call" do
    it "calls generate!" do
      expect_any_instance_of(described_class).to receive(:generate!)
      described_class.call
    end
  end
end
