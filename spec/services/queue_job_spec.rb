require "rails_helper"

RSpec.describe QueueJob do
  let(:job) { double(ProcessImageJob) }

  subject { described_class.new(job) }

  describe "#queue" do
    it "queues the job with #perform_later" do
      expect(subject).to receive(:process_in_background?).and_return(true)
      expect(job).to receive(:perform_later).with(test: "test")
      subject.queue(test: "test")
    end

    it "runs the job immediately with #perform_now" do
      expect(subject).to receive(:process_in_background?).and_return(false)
      expect(job).to receive(:perform_now).with(test: "test")
      subject.queue(test: "test")
    end
  end

  describe "#process_in_background?" do
    it "is true when configured" do
      expect(Rails.configuration.settings).to receive(:background_processing).and_return(true)
      expect(subject.send(:process_in_background?)).to be_truthy
    end

    it "is false when configured" do
      expect(Rails.configuration.settings).to receive(:background_processing).and_return(false)
      expect(subject.send(:process_in_background?)).to be_falsy
    end

    it "is false in test" do
      expect(subject.send(:process_in_background?)).to be_falsy
    end
  end
end
