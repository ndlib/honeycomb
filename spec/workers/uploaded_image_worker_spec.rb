require "rails_helper"

RSpec.describe UploadedImageWorker, type: :worker do
  subject { described_class.new }

  let (:queue) { subject.queue }

  let (:queue_options) { queue.opts.to_hash }

  describe "self" do
    subject { described_class }

    describe "#number_of_workers" do
      it "is 4" do
        expect(subject.number_of_workers).to eq(4)
      end
    end
  end

  describe "queue" do
    it "uses the correct queue name" do
      expect(queue.name).to eq("uploaded_images")
    end

    it "sets the correct queue options" do
      expect(queue_options[:arguments]).to eq(:"x-dead-letter-exchange" => "uploaded_images-retry")
      expect(queue_options[:handler]).to eq(Sneakers::Handlers::Maxretry)
      expect(queue_options[:routing_key]).to eq(["uploaded_images"])
      expect(queue_options[:threads]).to eq(1)
      expect(queue_options[:timeout_job_after]).to eq(60)
      expect(queue_options[:prefetch]).to eq(1)
    end
  end
end
