require 'rails_helper'

RSpec.describe HoneypotImageStyle, :type => :model do
  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/honeypot_response.json'))) }
  let(:style_json) { honeypot_json["image"]["links"]["styles"].first }
  let(:valid_attributes) { {id: 'original', width: 1920, height: 1200, type: "jpeg", src: "http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg"}}

  [:width, :height, :type, :src].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  describe 'self' do
    subject { described_class }

    it "can be initialized with a hash" do
      instance = subject.new(valid_attributes)
      valid_attributes.each do |key, value|
        expect(instance.send(key)).to eq(value)
      end
    end

    it "can be initialized with data from the json sample" do
      instance = subject.new(style_json)
      style_json.each do |key, value|
        expect(instance.send(key)).to eq(value)
      end
    end
  end
end
