require "rails_helper"

describe FindOrCreateUser do
  let(:username) { 'username' }
  subject { described_class.call(username)}


  it "returns a user when a user is found" do
    User.stub_chain(:where, :first).and_return(User.new({username: username}))
    expect(subject).to be_kind_of(User)
  end

  it "returns a user when a user is created" do
    User.stub(:nil).and_return(true)
    CreateUser.stub(:call).and_return(User.new({username: username}))
    expect(subject).to be_kind_of(User)
  end

  subject { described_class.call(nil)}
  it "returns a false when a user cannot be found or created" do
    expect(subject).to be(false)
  end

end
