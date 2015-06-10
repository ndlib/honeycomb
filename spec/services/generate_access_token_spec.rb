require "rails_helper"

describe "GenerateAccessToken" do
  subject { GenerateAccessToken }

  it "genrates a specific byte length access token" do
    expect(subject.call.length).to eq(40)
  end

  it "uses the SecureRandom interface" do
    expect(SecureRandom).to receive(:urlsafe_base64).with(30)
    subject.call
  end
end
