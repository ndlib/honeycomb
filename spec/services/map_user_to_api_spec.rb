require "rails_helper"

describe MapUserToApi do
  subject { MapUserToApi.call(user) }
  let(:user) { double(User, username: "username", "first_name=" => true, "last_name=" => true, "display_name=" => true, "email=" => true) }
  let(:api_data) do
    {
      "first_name" => "first_name",
      "last_name" => "last_name",
      "full_name" => "display_name",
      "contact_information" => { "email" => "email" }
    }
  end

  before(:each) do
    remove_user_api_stub
    allow(HesburghAPI::PersonSearch).to receive(:find).and_return(api_data)
  end

  it "calls the api for the user data" do
    expect(HesburghAPI::PersonSearch).to receive(:find).with(user.username).and_return(api_data)

    subject
  end

  it "does not raise an exception if one is encountered and notifies Sentry" do
    expect(HesburghAPI::PersonSearch).to receive(:find).with(user.username).and_raise("error encountered")
    expect(Raven).to receive(:capture_exception).and_call_original
    subject
  end

  [:first_name, :last_name].each do |field|
    it "sets the #{field} from the api data " do
      expect(user).to receive("#{field}=").with(api_data.fetch(field.to_s))
      subject
    end

    it "does not set the value if the api data is null" do
      api_data[field.to_s] = nil
      expect(user).to_not receive("#{field}=")
      subject
    end
  end

  context "display_name" do
    it "sets the value" do
      expect(user).to receive("display_name=").with(api_data.fetch("full_name"))
      subject
    end

    it "does not set the value if the api data is null" do
      api_data["full_name"] = nil
      expect(user).to_not receive("display_name=")
      subject
    end
  end

  context "email" do
    it "sets the value" do
      expect(user).to receive("email=").with(api_data["contact_information"]["email"])
      subject
    end

    it "does not set the value if the api data is null" do
      api_data["contact_information"]["email"] = nil
      expect(user).to_not receive("email=")
      subject
    end
  end
end
