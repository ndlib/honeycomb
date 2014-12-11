require 'rails_helper'

RSpec.describe HoneypotImage, :type => :model do
  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/honeypot_response.json'))) }
  [:width, :height, :host, :json_response, :title].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:width, :height, :host, :json_response, :title].each do | field |
    it "validates the #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  describe '#styles_data' do
    it "returns the styles hash from the json_response" do
      subject.json_response = honeypot_json
      expect(subject.send(:styles_data)).to eq({"original"=>{"width"=>1920, "height"=>1200, "type"=>"jpeg", "path"=>"/test/000/001/000/001/1920x1200.jpeg"}, "medium"=>{"width"=>1280, "height"=>800, "type"=>"jpeg", "path"=>"/test/000/001/000/001/medium/1920x1200.jpeg"}, "pyramid"=>{"width"=>1920, "height"=>1200, "type"=>"tiff", "path"=>"/test/000/001/000/001/pyramid/1920x1200.tif"}, "small"=>{"width"=>320, "height"=>200, "type"=>"jpeg", "path"=>"/test/000/001/000/001/small/1920x1200.jpeg"}})
    end

    it "returns an empty hash if the json_response is not present" do
      expect(subject.json_response).to eq({})
      expect(subject.send(:styles_data)).to eq({})
    end
  end

  describe '#styles' do
    it "returns style objects for each style" do
      subject.json_response = honeypot_json
      expect(subject.styles.count).to eq(4)
      subject.styles.each do |style_name, style_object|
        expect(style_object).to be_a_kind_of(HoneypotImageStyle)
      end
    end
  end

  describe '#style' do
    it "returns a style object for the specified style" do
      subject.json_response = honeypot_json
      original = subject.style(:original)
      expect(original.width).to eq(1920)
      expect(original.height).to eq(1200)
      expect(original.type).to eq("jpeg")
      expect(original.path).to eq("/test/000/001/000/001/1920x1200.jpeg")
    end
  end
end
