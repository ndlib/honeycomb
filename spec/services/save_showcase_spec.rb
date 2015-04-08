require "rails_helper"

RSpec.describe SaveShowcase, type: :model do
  subject { described_class.call(showcase, params) }
  let(:showcase) { Showcase.new }
  let(:params) { { title: 'title' } }
  let(:image) { File.new(Rails.root.join("spec/fixtures/test.jpg").to_s) }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(showcase).to receive(:save).and_return(true)
  end

  it "returns when the showcase save is successful" do
    expect(showcase).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the showcase save is not successful" do
    expect(showcase).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the showcase to be the passed in attributes " do
    expect(showcase).to receive(:attributes=).with(params)
    subject
  end

  describe "update_honeypot_image" do

    it "calls SaveHoneypotImage when there is an image"  do
      expect(SaveHoneypotImage).to receive(:call).with(showcase)
      params[:image] = image

      subject
    end

    it "does not call SaveHoneypotImage when there is not an image " do
      expect(SaveHoneypotImage).to_not receive(:call)
      subject
    end
  end

  describe "unique_id" do
    before(:each) do
      allow(showcase).to receive(:save).and_return(true)
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(showcase)
      subject
    end

    it "does not call create unique_id if the showcase does not save" do
      allow(showcase).to receive(:save).and_return(false)
      expect(CreateUniqueId).to_not receive(:call).with(showcase)
      subject
    end

  end
end
