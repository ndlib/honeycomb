require 'spec_helper'

describe SortableTitleConverter do
  let(:title) { "A Title"}
  subject { described_class.new(title) }

  describe '#original_title' do
    let(:title) { "Original Title" }
    it 'is the original title' do
      expect(subject.original_title).to eq("Original Title")
    end
  end

  describe '#converted_title' do
    it 'returns the raw title' do
      expect(subject).to receive(:original_title).and_return('raw_title')
      expect(subject.converted_title).to eq('raw_title')
    end

    it 'removes leading and trailing whitespace' do
      expect(subject).to receive(:original_title).and_return(' raw_title ')
      expect(subject.converted_title).to eq('raw_title')
    end

    it 'makes the title lowercase' do
      expect(subject).to receive(:original_title).and_return('Upper Title')
      expect(subject.converted_title).to eq('upper title')
    end

    %w(' " ` “ ‘ ’ ʻ).each do |quote|
      it "removes #{quote} quotes" do
        expect(subject).to receive(:original_title).and_return("#{quote} quote#{quote} quote")
        expect(subject.converted_title).to eq('quote quote')
      end
    end

    it 'removes parenthesis' do
      expect(subject).to receive(:original_title).and_return('(Parenthesis) Title')
      expect(subject.converted_title).to eq('parenthesis title')
    end

    %w(a an the).each do |article|
      it "removes leading '#{article}'" do
        expect(subject).to receive(:original_title).and_return("#{article} article")
        expect(subject.converted_title).to eq('article')
      end
    end

    it 'handles special characters' do
      expect(subject).to receive(:original_title).and_return("Émile Durkheim.")
      expect(subject.converted_title).to eq('emile durkheim.')
    end
  end

  describe 'self' do
    subject { described_class }

    describe '#convert' do
      it 'returns the converted_title' do
        expect(subject.convert('A Title')).to eq('title')
      end
    end
  end
end
