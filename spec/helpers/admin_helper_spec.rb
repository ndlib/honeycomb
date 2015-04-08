require 'rails_helper'

RSpec.describe AdminHelper do
  let(:user) { instance_double(User) }

  before do
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe '#admin_only' do
    it 'renders nothing if the user is not an admin' do
      expect(UserIsAdmin).to receive(:call).with(user).and_return(false)
      expect(helper.admin_only do
        'test'
      end).to be_nil
    end

    it 'renders content if the user is an admin' do
      expect(UserIsAdmin).to receive(:call).with(user).and_return(true)
      expect(helper.admin_only do
        'test'
      end).to eq('test')
    end
  end
end
