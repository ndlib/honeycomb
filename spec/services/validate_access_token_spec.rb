require "rails_helper"

describe "ValidateAccessToken", type: :controller do
  subject { ValidateAccessToken }
  let(:user) { User.new(first_name: "Joe", last_name: "Test", username: "joetest") }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    warden.set_user(user, store: true, run_callbacks: true)
  end

  it "sets the access token" do
    user_session = session["warden.user.user.session"]
    expect(warden.session[:token]).to eq user_session[:token]
  end

  it "validates the supplied access token" do
    user_session = @request.env["rack.session"]["warden.user.user.session"]
    expect(subject.call(user_session, warden.session[:token])).to be_truthy
  end
end
