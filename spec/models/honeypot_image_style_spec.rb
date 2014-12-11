require 'rails_helper'

RSpec.describe HoneypotImageStyle, :type => :model do
  let(:valid_attributes) { {width: 1920, height: 1200, type: "jpeg", path: "/test/000/001/000/001/1920x1200.jpeg"}}

  [:width, :height, :type, :path].each do | field |
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
  end
end
