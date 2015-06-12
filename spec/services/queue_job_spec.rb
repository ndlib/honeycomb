require "rails_helper"

RSpec.describe QueueJob do
  let(:job) { double(ProcessImageJob) }

  subject { described_class.new(job) }

  describe "#queue" do
    it "queues the job with #perform_later" do
      expect(job).to receive(:perform_later).with(test: "test")
      subject.queue(test: "test")
    end
  end
end
