require "rails_helper"

RSpec.describe NotifyError do
  let(:exception) { instance_double(StandardError, message: "An error") }
  let(:parameters) { { test: "test" } }
  let(:component) { "component" }
  let(:action) { "action" }
  let(:expected_environment) { { environment: "environment" } }
  let(:long_message) { (["a"] * 1100).join }
  let(:long_exception) do
    begin
      raise long_message
    rescue StandardError => e
      e
    end
  end

  describe "call" do
    subject { described_class.call(exception: exception, parameters: parameters, component: component, action: action) }

    before do
      allow(described_class).to receive(:environment_info).and_return(expected_environment)
    end

    it "calls Airbrake#notify" do
      expect(Airbrake).to receive(:notify).with(exception, component: component, action: action, parameters: parameters, cgi_data: expected_environment)
      subject
    end

    it "calls with default values" do
      expect(Airbrake).to receive(:notify).with(exception, component: nil, action: nil, parameters: {}, cgi_data: expected_environment)
      described_class.call(exception: exception)
    end

    context "long message" do
      let(:exception) { long_exception }

      it "logs the original exception in parameters" do
        expect(Airbrake).to receive(:notify).
          with(kind_of(exception.class), hash_including(parameters: { test: "test", original_exception: exception }))
        subject
      end
    end
  end

  context "environment_info" do
    subject { described_class.environment_info }

    before do
      allow(described_class).to receive(:environment_info).and_call_original
    end

    it "filters the environment data" do
      allow(Airbrake.configuration).to receive(:rake_environment_filters).and_return(["REJECT_KEY"])
      ENV["REJECT_KEY"] = "rejected"
      unfiltered_values = ENV.reject { false }
      filtered_values = ENV.reject { |k| k == "REJECT_KEY" }
      expect(subject).to_not eq(unfiltered_values)
      expect(subject).to eq(filtered_values)
    end
  end

  describe "clean_exception" do
    subject { described_class.clean_exception(exception) }

    it "returns the original exception if the message is a normal length" do
      expect(subject).to eq(exception)
    end

    context "long message" do
      let(:exception) { long_exception }

      it "returns a new exception" do
        expect(subject).to_not eq(exception)
      end

      it "limits the message length" do
        full_message = "#{subject.class}: #{subject.message}"
        expect(full_message.length).to eq(1000)
      end

      it "copies the backtrace" do
        expect(subject.backtrace).to eq(exception.backtrace)
        expect(subject.backtrace).to be_present
      end
    end
  end
end
