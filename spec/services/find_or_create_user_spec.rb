require "rails"

describe FindOrCreateUser do
  subject { described_class.call(username)}
  let(:username) { 'username' }


  it "returns a user when a user is found" do
    User.stub_chain(:where, :first).and_return(User.new({username: username}))
    expect(subject).to be_kind_of(User)
  end

  it "returns a user when a user is created" do
    User.stub(:nil).and_return(true)
    CreateUser.stub(:call).and_return(User.new({username: username}))
    expect(subject).to be_kind_of(User)
  end

  it "returns a false when a user cannot be found or created" do
    User.stub(:nil).and_return(true)
    expect(subject).to be(false)
  end

end
