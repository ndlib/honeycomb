require 'rails_helper'

describe Publish do
  subject { described_class.new(object) }
  let(:object) { double(Object, "published=" => true, save: true) }

  describe "#publish!" do

    it "sets the object to be published" do
      expect(object).to receive(:published=).with(true)
      subject.publish!
    end

    it "saves the object" do
      expect(object).to receive(:save).and_return(true)
      subject.publish!
    end

    it "returns true of the object is saved" do
      expect(subject.publish!).to be true
    end

    it "returns false if the object save fails " do
      allow(object).to receive("save").and_return(false)
      expect(subject.publish!).to be false
    end
  end

  describe "initilaize" do
    it "raises an error if the object is not duck typed" do
      expect { described_class.new(Object.new) }.to raise_error
    end
  end


  describe "#call" do

    it "calls publish!" do
      expect_any_instance_of(Publish).to receive(:publish!)
      described_class.call(object)
    end
  end
end
