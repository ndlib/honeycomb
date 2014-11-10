require 'rails'


describe MapUserToApi do

  subject { MapUserToApi.call(user) }
  let(:user) { double(User, username: 'username', 'first_name=' => true, 'last_name=' => true, 'display_name=' => true, 'email=' => true) }
  let(:api_data) { { 'data' => { 'first_name' => 'first_name', 'contact_information' => { 'email' => 'email'} } }}

  before(:each) do
    HesburghAPI::PersonSearch.stub(:find).and_return(api_data)
  end

  it "calls the api for the user data" do
    expect(HesburghAPI::PersonSearch).to receive(:find).with(user.username).and_return(api_data)
    subject
  end

  [:first_name, :last_name, :display_name].each do | field |
    it "set the #{field} from the api data " do
      expect(user).to receive("#{field}=").with(api_data['data']["#{field}"])
      subject
    end
  end
end
