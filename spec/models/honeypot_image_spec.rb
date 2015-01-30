require 'rails_helper'

RSpec.describe HoneypotImage, :type => :model do
  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/honeypot_response.json'))) }
  [:json_response, :title].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:json_response, :title].each do | field |
    it "validates the #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  describe '#image_json' do
    it "is the image value from the json" do
      subject.json_response = honeypot_json
      expect(subject.image_json).to eq(honeypot_json["image"])
    end

    it "is an empty hash if the json_response is not present" do
      expect(subject.image_json).to eq({})
    end
  end

  describe '#styles_data' do
    it "returns the styles hash from the json_response" do
      subject.json_response = honeypot_json
      expect(subject.send(:styles_data)).to eq([{"id"=>"original", "width"=>1920, "height"=>1200, "type"=>"jpeg", "src"=>"http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg"}, {"id"=>"medium", "width"=>1280, "height"=>800, "type"=>"jpeg", "src"=>"http://localhost:3019/images/test/000/001/000/001/medium/1920x1200.jpeg"}, {"id"=>"small", "width"=>320, "height"=>200, "type"=>"jpeg", "src"=>"http://localhost:3019/images/test/000/001/000/001/small/1920x1200.jpeg"}])
    end

    it "returns an empty hash if the json_response is not present" do
      subject.json_response = nil
      expect(subject.send(:styles_data)).to eq([])
    end
  end

  describe '#styles' do
    it "returns style objects for each style" do
      subject.json_response = honeypot_json
      expect(subject.styles.count).to eq(3)
      subject.styles.each do |style_name, style_object|
        expect(style_object).to be_a_kind_of(HoneypotImageStyle)
      end
    end
  end

  describe '#style' do
    it "returns a style object for the specified style" do
      subject.json_response = honeypot_json
      original = subject.style(:original)
      expect(original).to be_a_kind_of(HoneypotImageStyle)
      expect(original.width).to eq(1920)
      expect(original.height).to eq(1200)
      expect(original.type).to eq("jpeg")
      expect(original.src).to eq('http://localhost:3019/images/test/000/001/000/001/1920x1200.jpeg')
    end
  end

  describe '#dzi' do
    it "returns a style object for the dzi" do
      subject.json_response = honeypot_json
      dzi = subject.dzi
      expect(dzi).to be_a_kind_of(HoneypotImageStyle)
      expect(dzi.width).to eq(1920)
      expect(dzi.height).to eq(1200)
      expect(dzi.type).to eq("dzi")
      expect(dzi.src).to eq('http://localhost:3019/images/test/000/001/000/001/pyramid/1920x1200.tif.dzi')
    end
  end

  describe '#json_response=' do
    it "sets the title from the json" do
      expect(subject.title).to be_nil
      subject.json_response = honeypot_json
      expect(subject.title).to eq("1920x1200.jpeg")
    end
  end
end
