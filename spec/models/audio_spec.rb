require "rails_helper"

RSpec.describe Audio do
  it "inherits Media" do
    expect(described_class).to be < Media
  end

  [:allocated, :ready].each do |field|
    it "has enum, #{field}" do
      expect(subject).to respond_to("#{field}!")
      expect(subject).to respond_to("#{field}?")
    end
  end
end
