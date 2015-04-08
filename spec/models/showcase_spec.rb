require 'rails_helper'

RSpec.describe Showcase do
  [:title, :description, :unique_id, :image, :exhibit, :sections, :published, :collection].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:exhibit, :title].each do |field|
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  it 'has paper trail' do
    expect(subject).to respond_to(:versions)
  end

  describe '#has honeypot image interface' do
    it 'responds to image' do
      expect(subject).to respond_to(:image)
    end

    it 'responds to honeypot_image' do
      expect(subject).to respond_to(:honeypot_image)
    end

    it 'responds to collection' do
      expect(subject).to respond_to(:collection)
    end
  end
end
