require "rails_helper"

RSpec.describe V1::ImageJSONDecorator do
  subject { described_class.new(image) }
  let(:image) do
    instance_double(
      Image,
      status: "ready",
      image: paperclip_attachment,
      json_response: { "thumbnail/large" => { "contentUrl" => "image_uri" }, "contentUrl" => "base_url" }
    )
  end
  let(:paperclip_attachment) do
    instance_double(Paperclip::Attachment,
                    content_type: "image/jpeg",
                    original_filename: "filename",
                    name: "filename",
                    url: "image_uri",
                    width: 200,
                    height: 100)
  end
  let(:json) { double(Jbuilder, name: nil, width: nil, height: nil, status: nil, encodingFormat: nil, contentUrl: nil) }

  it "defines @context as schema.org" do
    expect(subject.at_context).to eq("http://schema.org")
  end

  it "defines @type as ImageObject" do
    expect(subject.at_type).to eq("ImageObject")
  end

  it "defines @id as the full url for the paperclip attachment" do
    expect(subject.at_id).to eq("image_uri")
  end

  it "defines name as the paperclip filename" do
    expect(image.image).to receive(:original_filename)
    subject.name
  end

  it "defines encoding_format as the paperclip content type" do
    expect(image.image).to receive(:content_type)
    subject.encoding_format
  end

  it "defines url as the full url for the paperclip attachment" do
    expect(subject.url).to eq("base_url")
  end

  it "defines width as the width of the paperclip attachment with the px suffix" do
    expect(subject.width).to eq("200 px")
  end

  it "defines height as the height of the paperclip attachment with the px suffix" do
    expect(subject.height).to eq("100 px")
  end

  describe "#display" do
    before(:each) do
      # Stubbing these out to return the params given to make it easier to
      # find out how the json set! calls are made within the private methods
      allow(subject).to receive(:width) { |params| params }
      allow(subject).to receive(:height) { |params| params }
      allow(subject).to receive(:url) { |params| params }
    end

    context "base image" do
      before(:each) do
        allow(json).to receive(:set!)
      end

      it "sets @context" do
        expect(json).to receive(:set!).with("@context", subject.at_context)
        subject.display(json: json)
      end

      it "sets @id, using the large style url" do
        expect(json).to receive(:set!).with("@id", style: :large)
        subject.display(json: json)
      end

      it "sets name" do
        expect(json).to receive(:name).with(subject.name)
        subject.display(json: json)
      end

      it "sets the image status" do
        expect(json).to receive(:status).with(subject.status)
        subject.display(json: json)
      end

      it "sets @type" do
        expect(json).to receive(:set!).with("@type", subject.at_type)
        subject.display(json: json)
      end

      it "sets width, using the large style width" do
        expect(json).to receive(:width).with(style: :large)
        subject.display(json: json)
      end

      it "sets height, using the large style height" do
        expect(json).to receive(:height).with(style: :large)
        subject.display(json: json)
      end

      it "sets encodingFormat" do
        expect(json).to receive(:encodingFormat).with(subject.encoding_format)
        subject.display(json: json)
      end

      it "sets contentUrl, using the large style url" do
        expect(json).to receive(:contentUrl).with(style: :large)
        subject.display(json: json)
      end
    end

    context "creates a thumbnail/small block" do
      it "sets @type" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/small") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:set!).with("@type", subject.at_type)
        subject.display(json: json)
      end

      it "sets encodingFormat, within the thumbnail/small block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/small") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:encodingFormat).with(subject.encoding_format)
        subject.display(json: json)
      end

      it "sets width, using the small style width, within the thumbnail/small block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/small") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:width).with(style: :small)
        subject.display(json: json)
      end

      it "sets height, using the small style height, within the thumbnail/small block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/small") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:height).with(style: :small)
        subject.display(json: json)
      end

      it "sets contentUrl, using the small style contentUrl, within the thumbnail/small block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/small") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:contentUrl).with(style: :small)
        subject.display(json: json)
      end
    end

    context "creates a thumbnail/medium block" do
      it "sets @type" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/medium") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:set!).with("@type", subject.at_type)
        subject.display(json: json)
      end

      it "sets encodingFormat, within the thumbnail/medium block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/medium") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:encodingFormat).with(subject.encoding_format)
        subject.display(json: json)
      end

      it "sets width, using the medium style width, within the thumbnail/medium block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/medium") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:width).with(style: :medium)
        subject.display(json: json)
      end

      it "sets height, using the medium style height, within the thumbnail/medium block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/medium") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:height).with(style: :medium)
        subject.display(json: json)
      end

      it "sets contentUrl, using the medium style contentUrl, within the thumbnail/medium block" do
        allow(json).to receive(:set!)
        expect(json).to receive(:set!).with("thumbnail/medium") do |&block|
          expect(block).to be_present
          block.call(json)
        end
        expect(json).to receive(:contentUrl).with(style: :medium)
        subject.display(json: json)
      end
    end
  end
end
