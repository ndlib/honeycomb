require "rails_helper"

RSpec.describe FindOrCreateImage do
  let(:attributes) do
    [
      { id: 0, collection_id: 1, image_fingerprint: "zero" },
      { id: 1, collection_id: 1, image_fingerprint: "one" },
      { id: 2, collection_id: 1, image_fingerprint: "two" },
      { id: 3, collection_id: 1, image_fingerprint: "three" }
    ]
  end
  let(:images) do
    [
      instance_double(Image, save: true, **attributes[0]),
      instance_double(Image, save: true, **attributes[1]),
      instance_double(Image, save: true, **attributes[2])
    ]
  end
  let(:new_images) do
    [
      instance_double(Image, save: true, **attributes[0]),
      instance_double(Image, save: true, **attributes[1]),
      instance_double(Image, save: true, **attributes[2]),
      instance_double(Image, save: true, **attributes[3])
    ]
  end
  let(:image_records) do
    [
      double(Image, take: images[0], **attributes[0]),
      double(Image, take: images[1], **attributes[1]),
      double(Image, take: images[2], **attributes[2]),
      double(Image, take: nil, **attributes[3])
    ]
  end

  before(:each) do
    allow(Image).to receive(:new) do |params|
      new_images[params[:image]]
    end
    allow(Image).to receive(:where) do |_clause, collection_id, image_fingerprint|
      image_records.detect { |image| image.collection_id == collection_id && image.image_fingerprint == image_fingerprint }
    end
  end

  it "returns an existing record for ones that exist" do
    expect(FindOrCreateImage.call(file: 0, collection_id: 1)).to eq(images[0])
    expect(FindOrCreateImage.call(file: 1, collection_id: 1)).to eq(images[1])
    expect(FindOrCreateImage.call(file: 2, collection_id: 1)).to eq(images[2])
  end

  context "when an image doesn't exist yet" do
    it "returns a new one" do
      allow(QueueJob).to receive(:call).and_return(true)
      allow(new_images[3]).to receive(:save).and_return(true)
      expect(FindOrCreateImage.call(file: 3, collection_id: 1)).to eq(new_images[3])
    end

    it "returns false if a new image save fails" do
      allow(new_images[3]).to receive(:save).and_return(false)
      expect(FindOrCreateImage.call(file: 3, collection_id: 1)).to eq(false)
    end

    it "sets the invalid state when the class receives a sneakers connection error" do
      allow(QueueJob).to receive(:call).and_raise(Bunny::TCPConnectionFailedForAllHosts)
      expect(new_images[3]).to receive(:unavailable!)
      FindOrCreateImage.call(file: 3, collection_id: 1)
    end

    it "Queues image processing if the image was updated" do
      allow(new_images[3]).to receive(:processing!).and_return(true)
      allow(new_images[3]).to receive(:save).and_return(true)
      expect(QueueJob).to receive(:call).with(ProcessImageJob, object: new_images[3]).and_return(true)
      FindOrCreateImage.call(file: 3, collection_id: 1)
    end
  end
end
