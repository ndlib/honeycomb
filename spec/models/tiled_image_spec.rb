require "rails_helper"

RSpec.describe TiledImage do
  [:width, :height, :url].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "validates the width" do
    expect(subject).to have(1).error_on(:width)
  end

  it "validates the height" do
    expect(subject).to have(1).error_on(:height)
  end

  it "validates the url" do
    expect(subject).to have(1).error_on(:url)
  end

end
