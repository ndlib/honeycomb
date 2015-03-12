require 'rails_helper'

RSpec.describe HoneypotThumbnail do
  let(:honeypot_image) { double(HoneypotImage, image_json: {}) }
  subject { described_class.new(honeypot_image) }

  describe '#react_thumbnail' do
    it 'renders a react component' do
      expect(subject.display).to match("<div data-react-class=\"Thumbnail\"")
    end
  end

end
