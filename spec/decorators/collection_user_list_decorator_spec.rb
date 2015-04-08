require 'rails_helper'

RSpec.describe CollectionUserListDecorator do
  let(:collection_user) { instance_double(CollectionUser) }
  subject { described_class.new([collection_user]) }

  describe '#editor_hashes' do
    it 'returns an array of hashes' do
      expect_any_instance_of(CollectionUserDecorator).to receive(:editor_hash).and_return(test: :test)
      result = subject.editor_hashes
      expect(result).to be_a_kind_of(Array)
      expect(result.first).to eq(test: :test)
    end
  end
end
