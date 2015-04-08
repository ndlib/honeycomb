require "rails_helper"

RSpec.describe SaveExhibit, type: :model do
  subject { described_class.call(exhibit, params) }
  let(:exhibit) { Exhibit.new }
  let(:params) { { title: 'title' } }
  let(:image) { File.new(Rails.root.join("spec/fixtures/test.jpg").to_s) }

  before(:each) do
    allow(exhibit).to receive(:save).and_return(true)
  end

  describe "update_honeypot_image" do

    it "calls SaveHoneypotImage when there is an image"  do
      expect(SaveHoneypotImage).to receive(:call).with(exhibit)
      params[:image] = image

      subject
    end

    it "does not call SaveHoneypotImage when there is not an image " do
      expect(SaveHoneypotImage).to_not receive(:call)
      subject
    end
  end

end
