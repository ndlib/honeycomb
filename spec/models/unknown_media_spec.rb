require "rails_helper"

RSpec.describe UnknownMedia do
  let(:subject) { UnknownMedia.new(media_type: "Foo") }

  [:media_type].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:json_response].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
    end
  end

  it "is not valid" do
    expect(subject.valid?).to eq(false)
  end

  it "has media_type errors" do
    expect(subject.errors).to eq(:error => [{:name=>"media_type", :description=>"Unknown media type 'Foo'"}])
  end


end
