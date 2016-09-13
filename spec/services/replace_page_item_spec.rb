require "rails_helper"

describe ReplacePageItem do
  let(:page_content) { File.read(Rails.root.join("spec/fixtures/sample_page_content.txt")) }
  let(:collection) { Collection.new(id: 1) }
  let(:page) { Page.new(id: 1, content: page_content, collection: collection, collection_id: collection.id) }
  let(:item) { Item.new(unique_id: "ec625c51db", pages: [page]) }
  subject { described_class.call(page, item) }

  it "calls #replace!" do
    expect_any_instance_of(described_class).to receive(:replace!)
    subject
  end

  describe "#replace!" do
    it "replaces the changed item src target" do
      expect_any_instance_of(described_class).to receive(:new_image_uri).exactly(2).times.and_return("http://no.where")
      expect(page).to receive(:save!).and_return(true)
      subject
      expect(Nokogiri::HTML::DocumentFragment.parse(page.content).css(".hc_page_image").first["src"]).to eq "http://no.where"
    end

    it "replaces the changed item data-save-url target" do
      expect_any_instance_of(described_class).to receive(:new_image_uri).exactly(2).times.and_return("http://no.where")
      expect(page).to receive(:save!).and_return(true)
      subject
      expect(Nokogiri::HTML::DocumentFragment.parse(page.content).css(".hc_page_image").first["data-save-url"]).to eq "http://no.where"
    end
  end

  it "correctly retrieves the url from item media" do
    data = { "thumbnail/medium" => { "contentUrl" => "http://no.where" }}
    expect(page).to receive(:json_response).exactly(2).times.and_return(data)
    expect(page).to receive(:save!).and_return(true)
    expect(item).to receive(:media).exactly(2).times.and_return(page)

    subject
  end
end
