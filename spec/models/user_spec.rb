require "rails_helper"

RSpec.describe User do
  before(:each) do
    allow(MapUserToApi).to receive(:call).and_return(true)
  end

  [:username, :first_name, :last_name, :display_name, :email].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:username].each do |field|
    it "requires field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  it "is valid and saves with just a username" do
    user = described_class.new(username: "testuser")
    expect(user).to be_valid
    expect(user.save).to eq(true)
  end

  it "uses MapUserToApi when user saved" do
    expect(MapUserToApi).to receive(:call)
    User.new.save
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  context "foreign key constraints" do
    describe "#destroy" do
      it "fails if a collection_user references it" do
        subject = FactoryGirl.create(:default_user)
        FactoryGirl.create(:collection)
        FactoryGirl.create(:collection_user, user_id: 1)
        expect { subject.destroy }.to raise_error
      end
    end
  end
end
