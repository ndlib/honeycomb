require 'rails_helper'

RSpec.describe ItemImageDecorator do
  describe 'valid object' do
    let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/honeypot_response.json'))) }
    let(:honeypot_image) do
      HoneypotImage.new.tap do |image|
        image.json_response = honeypot_json
      end
    end
    subject { described_class.new(honeypot_image) }

    it 'has a title' do
      expect(subject.title).to eq("1920x1200.jpeg")
    end

    describe '#render' do
      it 'renders' do
        expect(subject.render(:small)).to eq("<img alt=\"1920x1200\" src=\"http://localhost:3019/images/test/000/001/000/001/small/1920x1200.jpeg\" />")
      end
    end

    describe '#render_image_zoom' do
      it 'renders' do
        expect(subject.render_image_zoom).to eq("<div class=\"image-zoom image-zoom-immediate\" data-target=\"http://localhost:3019/images/test/000/001/000/001/pyramid/1920x1200.tif.dzi\" id=\"imageZoom1\" style=\"width: 100%; height: 100%\"></div>")
      end

      it 'returns nil if there is no dzi' do
        allow(subject).to receive(:dzi).and_return(nil)
        expect(subject.render_image_zoom).to be_nil
      end
    end

    describe '#style_with_fallback' do
      it 'returns the requested style if it exists' do
        style = subject.style_with_fallback(:small)
        expect(style).to be_a_kind_of(HoneypotImageStyle)
        expect(style.id).to eq('small')
      end

      it 'returns the original if the requested does not exist' do
        style = subject.style_with_fallback(:fake)
        expect(style).to be_a_kind_of(HoneypotImageStyle)
        expect(style.id).to eq('original')
      end
    end

    describe '#original_style' do
      it 'returns the original' do
        original = subject.original_style
        expect(original).to be_a_kind_of(HoneypotImageStyle)
        expect(original.id).to eq('original')
      end
    end

    describe '#dzi' do
      it 'returns the dzi' do
        dzi = subject.dzi
        expect(dzi).to be_a_kind_of(HoneypotImageStyle)
        expect(dzi.id).to eq('dzi')
      end
    end

    describe '#style' do
      it 'returns the requested style if it exists' do
        style = subject.style(:small)
        expect(style).to be_a_kind_of(HoneypotImageStyle)
        expect(style.id).to eq('small')
      end

      it 'returns nil if the requested style does not exist' do
        expect(subject.style(:fake)).to be_nil
      end
    end
  end

  describe 'nil object' do
    subject { described_class.new(nil) }

    it 'has no title' do
      expect(subject.title).to be_nil
    end

    describe '#render' do
      it 'returns nil' do
        expect(subject.render(:small)).to be_nil
      end
    end

    describe '#render_image_zoom' do
      it 'returns nil' do
        expect(subject.render_image_zoom).to be_nil
      end
    end
  end
end
