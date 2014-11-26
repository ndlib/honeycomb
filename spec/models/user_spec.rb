require "rails_helper"

RSpec.describe User do

  before(:each) do
    MapUserToApi.stub(:call).and_return(true)
  end

  [:username, :first_name, :last_name, :display_name, :email].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:username].each do | field |
    it "requires field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  it "uses MapUserToApi when user saved" do
    expect(MapUserToApi).to receive(:call)
    User.new.save
  end

end
