describe UserIsAdmin do
  subject { described_class.call(user) }
  let(:user) { double(User, id: '1') }

  it 'returns when a User is found' do
    expect(user).to receive(:admin?).and_return(true)
    expect(subject).to be(true)
  end

  it 'returns false when a User is not found' do
    expect(user).to receive(:admin?).and_return(false)
    expect(subject).to be(false)
  end
end
