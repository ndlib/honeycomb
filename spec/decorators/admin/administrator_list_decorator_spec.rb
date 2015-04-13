require 'rails_helper'

RSpec.describe Admin::AdministratorListDecorator do
  let(:user) { instance_double(User) }
  subject { described_class.new([user]) }

  describe '#administrator_hashes' do
    it 'returns an array of hashes' do
      expect_any_instance_of(Admin::AdministratorDecorator).to receive(:to_hash).and_return(test: :test)
      result = subject.administrator_hashes
      expect(result).to be_a_kind_of(Array)
      expect(result.first).to eq(test: :test)
    end
  end
end
