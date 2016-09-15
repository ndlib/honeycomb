require "rails_helper"

RSpec.describe Thumbnail do
  let(:image) { double(Image, json_response: {}) }
  subject { described_class.new(image, "image") }

  describe "#react_thumbnail" do
    it "renders a react component" do
      expect(subject.display).to match("<div data-react-class=\"Thumbnail\"")
    end

    it "renders default if image is nil" do
      expect(described_class.new(nil, "image").display).to eq(
        "<div data-react-class=\"Thumbnail\" data-react-props=\"{&quot;thumbnailUrl&quot;:&quot;&quot;,&quot;extraStyle&quot;:{},&quot;thumbType&quot;:&quot;image&quot;}\"></div>"
      )
    end
  end
end
