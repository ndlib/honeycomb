require 'rails'

describe RevokeAdminOnUser do

  subject { RevokeAdminOnUser.call(user) }

  let(:user) { double(User, username: 'username', 'first_name=' => true, 'last_name=' => true, 'display_name=' => true, 'email=' => true) }

  it "re admin to false and save user" do
    expect(user).to receive("admin=").with(false)
    expect(user).to receive("save")
    subject
  end
end
