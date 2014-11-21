require "rails"

describe CreateUser do

  subject { CreateUser.call(user, params)}
  let(:user) { double(User, username: 'username', 'first_name=' => true, 'last_name=' => true, 'display_name=' => true, 'email=' => true) }
  let(:params) { { 'first_name=' => 'first_name' } }
  it "has attributes set from params" do

  end

  it "assign attributes and saves the user" do
    expect(user).to receive("attributes=").with(params)
    expect(user).to receive("save")
    subject
  end

end
