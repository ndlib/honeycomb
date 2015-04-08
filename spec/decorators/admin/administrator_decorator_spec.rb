require 'rails_helper'

RSpec.describe Admin::AdministratorDecorator do
  let(:user) { instance_double(User, id: 1, username: 'username', display_name: 'display_name') }
  subject { described_class.new(user) }

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
      expect(subject.destroy_path).to eq('/admin/administrators/1')
    end
  end

  describe '#to_hash' do
    it 'returns a hash' do
      expect(subject.to_hash).to be_a_kind_of(Hash)
      expect(subject.to_hash).to eq(id: 1, username: 'username', name: 'display_name', removeUrl: '/admin/administrators/1')
    end
  end

  describe '#to_json' do
    it 'returns JSON' do
      test_hash = { test: :test }
      expect(subject).to receive(:to_hash).and_return(test_hash)
      expect(subject.to_json).to eq(test_hash.to_json)
    end
  end
end
