require 'spec_helper'

describe URIParser do
  let(:valid_uri) { 'http://library.nd.edu/path' }
  let(:invalid_uri) { 'path' }
  subject { described_class.new(valid_uri) }

  it 'sets the uri' do
    expect(subject.uri).to eq(valid_uri)
  end

  it 'parses the uri' do
    parsed = subject.parse
    expect(parsed).to be_a_kind_of(Addressable::URI)
    expect(parsed.host).to eq('library.nd.edu')
    expect(parsed.path).to eq('/path')
    expect(parsed.scheme).to eq('http')
  end

  describe 'self' do
    subject { described_class }
    describe '#call' do
      it 'returns a parsed uri' do
        result = subject.call(valid_uri)
        expect(result).to be_a_kind_of(Addressable::URI)
        expect(result.host).to eq('library.nd.edu')
        expect(result.path).to eq('/path')
        expect(result.scheme).to eq('http')
      end
    end

    describe '#valid?' do
      it 'is true for a valid uri' do
        expect(subject.valid?(valid_uri)).to eq(true)
      end

      it 'is false for a invalid uri' do
        expect(subject.valid?(invalid_uri)).to eq(false)
      end
    end
  end
end
