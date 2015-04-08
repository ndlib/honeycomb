require 'rails_helper'

RSpec.describe CollectionUserDecorator do
  let(:user) { instance_double(User, display_name: 'display_name', username: 'username') }
  let(:collection_user) { instance_double(CollectionUser, user_id: 1, collection_id: 2, user: user) }
  subject { described_class.new(collection_user) }

  describe '#id' do
    it 'is the user id' do
      expect(subject.id).to eq(1)
    end
  end

  describe '#name' do
    it 'is the user display_name' do
      expect(user).to receive(:display_name).and_return('Name')
      expect(subject.name).to eq('Name')
    end
  end

  describe '#username' do
    it 'is the user username' do
      expect(user).to receive(:username).and_return('Username')
      expect(subject.username).to eq('Username')
    end
  end

  describe '#destroy_path' do
    it 'is the destroy path' do
      expect(subject.destroy_path).to eq('/collections/2/editors/1')
    end
  end

  describe '#editor_hash' do
    it 'returns a hash' do
      expect(subject.editor_hash).to be_a_kind_of(Hash)
      expect(subject.editor_hash).to eq(id: 1, name: 'display_name', username: 'username', removeUrl: '/collections/2/editors/1')
    end
  end

  describe '#editor_json' do
    it 'returns JSON' do
      test_hash = { test: :test }
      expect(subject).to receive(:editor_hash).and_return(test_hash)
      expect(subject.editor_json).to eq(test_hash.to_json)
    end
  end
end
