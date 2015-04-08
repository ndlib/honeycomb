require "rails_helper"

describe CreateUser do

  let(:user) { double(User, username: 'username', 'first_name=' => true, 'last_name=' => true, 'display_name=' => true, 'email=' => true) }
  let(:params) { { 'first_name=' => 'first_name', 'last_name=' => 'last_name', 'display_name=' => 'display_name', 'email=' => 'email' } }
  subject { described_class.call(user, params)}

 it "responds to first_name with the first_name from params" do
    expect(user).to respond_to("first_name=")
  end

  it "assign attributes and saves the user" do
    expect(user).to receive("attributes=").with(params)
    expect(user).to receive("save")
    subject
  end

end
