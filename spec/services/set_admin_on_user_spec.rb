require 'rails'

describe SetAdminOnUser do

  subject { SetAdminOnUser.call(user) }

  let(:user) { double(User, username: 'username', 'first_name=' => true, 'last_name=' => true, 'display_name=' => true, 'email=' => true) }

  it "set admin to true and save user" do
    expect(user).to receive("admin=").with(true)
    expect(user).to receive("save")
    subject
  end
end
