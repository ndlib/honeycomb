require "rails_helper"

describe ReplacePageItem do
  let(:page_content) { File.read(Rails.root.join("spec/fixtures/sample_page_content.txt")) }
  let(:collection) { Collection.new(id: 1) }
  let(:page) { Page.new(id: 1, content: page_content, collection: collection, collection_id: collection.id, ) }
  let(:image) { instance_double(Image, type: "Image") }
  let(:video) { instance_double(Video, type: "Video") }
  let(:audio) { instance_double(Audio, type: "Audio") }
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

  it "correctly retrieves the url from item image" do
    data = { "thumbnail/medium" => { "contentUrl" => "http://no.where" }}
    allow(page).to receive(:save!).and_return(true)
    allow(item).to receive(:media).and_return(image)
    expect(image).to receive(:json_response).exactly(2).times.and_return(data)

    subject
  end

  it "correctly retrieves the url from item video" do
    data = { "thumbnail/medium" => { "contentUrl" => "http://no.where" }}
    allow(page).to receive(:save!).and_return(true)
    allow(item).to receive(:media).and_return(video)
    expect(video).to receive(:thumbnail_url).exactly(2).times.and_return(data)

    subject
  end

  it "correctly retrieves the url from item audio" do
    data = { "thumbnail/medium" => { "contentUrl" => "http://no.where" }}
    allow(page).to receive(:save!).and_return(true)
    allow(item).to receive(:media).and_return(audio)
    expect(audio).to receive(:thumbnail_url).exactly(2).times.and_return(data)

    subject
  end
end
