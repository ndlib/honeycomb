require "rails"
require "rails_helper"

describe SiteObjectsQuery do
  let(:showcases) do
    [
      instance_double(Showcase, id: 0, collection_id: 1, unique_id: "zero", class: double(Object, name: "Showcase")),
      instance_double(Showcase, id: 1, collection_id: 1, unique_id: "one", class: double(Object, name: "Showcase")),
      instance_double(Showcase, id: 2, collection_id: 1, unique_id: "two", class: double(Object, name: "Showcase"))
    ]
  end
  let(:pages) do
    [
      instance_double(Page, id: 0, collection_id: 1, unique_id: "zero", class: double(Object, name: "Page")),
      instance_double(Page, id: 1, collection_id: 1, unique_id: "one", class: double(Object, name: "Page")),
      instance_double(Page, id: 2, collection_id: 1, unique_id: "two", class: double(Object, name: "Page"))
    ]
  end
  let(:users) do
    [
      instance_double(User, id: 0, unique_id: "zero", class: double(Object, name: "User")),
      instance_double(User, id: 1, unique_id: "one", class: double(Object, name: "User")),
      instance_double(User, id: 2, unique_id: "two", class: double(Object, name: "User"))
    ]
  end
  let(:site_path_string) { '[{ "type": "Showcase", "id": 0 }, { "type": "Page", "id": 2 }, { "type": "Showcase", "id": 2 }]' }
  let(:site_path) { [showcases[0], pages[2], showcases[2]] }
  let(:collection) { instance_double(Collection, id: 1, site_path: site_path_string) }

  before(:each) do
    allow(Collection).to receive(:find).and_return(collection)
    allow(Showcase).to receive(:find) do |id|
      showcases[id]
    end
    allow(Page).to receive(:find) do |id|
      pages[id]
    end
    allow(User).to receive(:find) do |id|
      users[id]
    end
  end

  it "returns all site objects as a json" do
    expect(subject.all(collection: collection)).to eq(site_path)
  end

  it "returns empty array if site_path is nil" do
    allow(collection).to receive(:site_path).and_return(nil)
    expect(subject.all(collection: collection)).to eq([])
  end

  it "returns empty array if site_path is empty string" do
    allow(collection).to receive(:site_path).and_return("")
    expect(subject.all(collection: collection)).to eq([])
  end

  # The json string will be formed by code, not by a user, so if something goes
  # wrong, we should know about it
  it "throws an exception if the site_path json is malformed" do
    allow(collection).to receive(:site_path).and_return("[")
    expect { subject.all(collection: collection) }.to raise_error
  end

  context "when asking if an object exists in the array" do
    it "returns false if the object given is not in the site_path array" do
      expect(subject.exists?(collection_object: showcases[1])).to eq(false)
    end

    it "finds the previous object" do
      expect(subject.exists?(collection_object: pages[2])).to eq(true)
    end

    it "returns true if the object given is in the site_path array" do
      expect(subject.exists?(collection_object: showcases[0])).to eq(true)
    end
  end

  context "when finding previous" do
    it "returns nil if the object given is not in the site_path array" do
      expect(subject.previous(collection_object: showcases[1])).to eq(nil)
    end

    it "finds the previous object" do
      expect(subject.previous(collection_object: pages[2])).to eq(showcases[0])
    end

    it "returns nil if there is no previous object" do
      # Since there are multiple paths to return nil, this first expectation is to ensure
      # that it finds the object
      expect(subject.next(collection_object: showcases[0])).to eq(pages[2])
      expect(subject.previous(collection_object: showcases[0])).to eq(nil)
    end
  end

  context "when finding next" do
    it "returns nil if the object given is not in the site_path array" do
      expect(subject.next(collection_object: showcases[1])).to eq(nil)
    end

    it "finds the next object" do
      expect(subject.next(collection_object: pages[2])).to eq(showcases[2])
    end

    it "returns nil if there is no next object" do
      # Since there are multiple paths to return nil, this first expectation is to ensure
      # that it finds the object
      expect(subject.previous(collection_object: showcases[2])).to eq(pages[2])
      expect(subject.next(collection_object: showcases[2])).to eq(nil)
    end
  end

  context "invalid object types" do
    let(:site_path_string) { '[{ "type": "Showcase", "id": 0 }, { "type": "User", "id": 2 }, { "type": "Showcase", "id": 2 }]' }
    let(:site_path) { [showcases[0], users[2], showcases[2]] }

    it "raises an exception" do
      expect { subject.all(collection: collection) }.to raise_error
    end
  end

  describe "public_to_private_json" do
    let(:public_site_path_string) do
      '[{ "type": "Showcase", "unique_id": "zero" },
        { "type": "Page", "unique_id": "two" },
        { "type": "Showcase", "unique_id": "two" }]'
    end

    before(:each) do
      allow(Collection).to receive(:find).and_return(collection)
      allow(Showcase).to receive(:find_by!) do |param|
        (showcases.select { |object| object.unique_id == param[:unique_id] })[0]
      end
      allow(Page).to receive(:find_by!) do |param|
        (pages.select { |object| object.unique_id == param[:unique_id] })[0]
      end
      allow(User).to receive(:find_by!) do |param|
        (users.select { |object| object.unique_id == param[:unique_id] })[0]
      end
    end

    it "converts to the same json string using correct ids" do
      expect(JSON.parse(subject.public_to_private_json(json_string: public_site_path_string))).to eq(JSON.parse(site_path_string))
    end
  end
end
