require "rails_helper"

RSpec.describe Video do
  it "inherits Media" do
    expect(described_class).to be < Media
  end

  [:file_name, :json_response].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:allocated, :ready].each do |field|
    it "has enum, #{field}" do
      expect(subject).to respond_to("#{field}!")
      expect(subject).to respond_to("#{field}?")
    end
  end
end
