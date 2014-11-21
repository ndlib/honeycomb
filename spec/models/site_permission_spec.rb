require 'rails'

describe SitePermission do
  subject { described_class.new(user, controller) }
  let(:user) { double(User) }
  let(:controller) { ApplicationController.new }
  let(:collection) { double(Collection) }

  it "returns true when user is administrator" do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(true)
    expect(subject.user_is_administrator?).to be(true)
  end

  it "returns false when user is not an administrator" do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(false)
    expect(subject.user_is_administrator?).to be(false)
  end

  it "returns true if the masqing users is an admin " do
    Masquerade.any_instance.stub(:masquerading?).and_return(true)
    Masquerade.any_instance.stub(:user).and_return(user)
  end

  it "returns true if the masqing users is an admin " do
    Masquerade.any_instance.stub(:masquerading?).and_return(false)
    Masquerade.any_instance.stub(:user).and_return(false)
  end

  it "returns true when a user is a curator" do
    expect(UserIsCurator).to receive(:call).with(user, collection).and_return(true)
    expect(subject.user_is_curator?(collection)).to be(true)
  end

  it "returns false when a user is not a curator" do
    expect(UserIsCurator).to receive(:call).with(user, collection).and_return(false)
    expect(subject.user_is_curator?(collection)).to be(false)
  end

end
