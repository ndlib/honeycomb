require 'rails_helper'

describe CreateUniqueId do
  subject { described_class.new(object) }
  let(:object) { double(id: 1, class: "Class", unique_id: nil, "unique_id=" => true, save: true) }

  it "generates a id" do
    expect(object).to receive(:unique_id=).with("6187bbca38")
    subject.create!

  end

  it "uses the md5 lib to generate the id " do
    expect(Digest::MD5).to receive(:hexdigest).with("#{object.id}-#{object.class}").and_return("adfadfafsdadsdasdafs")
    subject.create!
  end

  it "sets a unique_id when it is saved and one does not exist" do
    expect(object).to receive(:unique_id=)
    subject.create!
  end

  it "returns true on save succes" do
    expect(subject.create!).to eq(true)
  end

  it "returns false on save failure" do
    allow(object).to receive(:save).and_return(false)
    expect(subject.create!).to eq(false)
  end


  describe "existing unique_id" do
    before(:each) do
      allow(object).to receive(:unique_id).and_return('1231232')
    end

    it "does not set unique_id when it is saved and one exists" do
      expect(object).to_not receive(:unique_id=)
      subject.create!
    end

    it "returns true" do
      expect(subject.create!).to eq(true)
    end
  end

  describe "initilaize" do
    it "raises an error if the object is not duck typed" do
      expect { described_class.new(Object.new) }.to raise_error
    end
  end


  describe "#call" do

    it "calls publish!" do
      expect_any_instance_of(described_class).to receive(:create!)
      described_class.call(object)
    end
  end


end
