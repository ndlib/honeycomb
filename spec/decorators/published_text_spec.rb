require 'rails_helper'

RSpec.describe PublishedText do
  subject { described_class.new(object) }
  let(:object) { double(published: true) }

  describe '#display' do
    it 'displays the published text' do
      expect(subject.display).to eq("<span class=\"text-success\"><i class=\"glyphicon glyphicon-ok\"></i> Published</span>")
    end

    it 'displays the unpublished text' do
      allow(object).to receive(:published).and_return(false)
      # expect(subject.display).to eq("<span class=\"text-muted\"><i class=\"glyphicon glyphicon-ok\"></i> Not published</span>")
    end
  end

  describe 'class#display' do
    it 'calls the instance method' do
      expect(described_class).to receive(:display)
      described_class.display(object)
    end
  end
end
