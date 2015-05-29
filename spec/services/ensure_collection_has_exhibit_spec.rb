require "rails_helper"

describe EnsureCollectionHasExhibit do
  subject { described_class.call(collection) }

  let(:exhibit) { double(Exhibit, id: 1) }

  context "has exhibit" do
    let(:collection) { double(Collection, id: 1, exhibit: exhibit, name_line_1: "name_line_1", create_exhibit: true) }

    it "does not create a new one" do
      expect(collection).to_not receive(:create_exhibit)
      subject
    end

    it "returns the exhibit" do
      expect(subject).to eq(exhibit)
    end
  end

  context "no current exhibit" do
    let(:collection) { double(Collection, id: 1, exhibit: nil, name_line_1: "name_line_1", create_exhibit: true) }

    it "creates the exhibit" do
      expect(collection).to receive(:create_exhibit)
      subject
    end

    it "uses the collection title" do
      expect(collection).to receive(:create_exhibit).with(hash_including(name: collection.name_line_1))
      subject
    end

    it "uses the correct copyright as a default" do
      default_copyright = "<p><a href=\"http://www.nd.edu/copyright/\">Copyright</a> " +
                          Date.today.year.to_s +
                          " <a href=\"http://www.nd.edu\">University of Notre Dame</a></p>"
      expect(collection).to receive(:create_exhibit).with(hash_including(copyright: default_copyright))
      subject
    end
  end
end
