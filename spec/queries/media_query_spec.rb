require "rails"

describe MediaQuery do
  subject { described_class.new(relation) }
  let(:relation) { Media.all }

  describe "public_find" do
    it "calls public_find!" do
      expect(relation).to receive(:find_by!).with(uuid: "asdf")
      subject.public_find("asdf")
    end

    it "raises an error on not found" do
      expect { subject.public_find("asdf") }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
