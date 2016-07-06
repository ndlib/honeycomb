require "rails_helper"

RSpec.describe HoneypotThumbnail do
  let(:image) { double(Image, json_response: {}) }
  subject { described_class.new(image) }

  describe "#react_thumbnail" do
    it "renders a react component" do
      expect(subject.display).to match("<div data-react-class=\"Thumbnail\"")
    end

    it "renders nothing if the honeypot_image is nil" do
      expect(described_class.new(nil).display).to eq("")
    end
  end
end
