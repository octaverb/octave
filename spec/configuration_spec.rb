require "spec_helper"

module Octave
  RSpec.describe Configuration do
    let(:config) { Configuration.new }

    describe ".new" do
      subject { Configuration.new }

      it "sets the max queue" do
        expect(subject.max_queue).to eq 1500
      end

      it "sets the logger" do
        expect(subject.logger).to be_a(Logger)
      end

      it "is enabled" do
        expect(subject.enabled?).to be_truthy
      end
    end

    describe "#dispatchers" do
      subject { config.dispatchers }

      it "returns the default dispatcher" do
        expect(subject).to all(be_a(Dispatcher::Logger))
      end

      context "with set dispatchers" do
        it "returns configured dispatchers" do
          dispatcher = double("dispatcher")
          config.dispatchers = [dispatcher]

          expect(subject).to eq [dispatcher]
        end
      end
    end
  end
end