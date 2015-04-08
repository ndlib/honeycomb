require 'rails_helper'

RSpec.describe DisplayFlashMessage do
  subject { described_class.new(flash) }
  let(:flash) { {} }

  described_class::KEY_2_CSS_CLASS.each do |key, css_class|
    it 'displays the flash messages for notices' do
      flash[key] = 'flash'
      expect(subject.display).to eq("<div class=\"#{css_class}\">\n  flash\n</div>\n")
    end
  end
end
