describe UserIsEditor do
  subject { described_class.call(user, collection) }
  let(:user) { double(User, id: '1') }
  let(:collection) { double(Collection, id: '1') }

  it 'returns when a CollectionUser is found' do
    CollectionUser.stub_chain(:where, :first).and_return(true)
    expect(subject).to be(true)
  end

  it 'returns false when a CollectionUser is not found' do
    CollectionUser.stub_chain(:where, :first).and_return(false)
    expect(subject).to be(false)
  end
end
