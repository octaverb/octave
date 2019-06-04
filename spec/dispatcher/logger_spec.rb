require "spec_helper"

module Octave
  module Dispatcher
    RSpec.describe Logger do
      describe "::new" do
        context "with a predefined logger" do
          let(:logger) { double("logger") }

          subject { described_class.new(logger) }

          it "sets the logger" do
            expect(subject.logger).to eq logger
          end
        end

        context "without args" do
          subject { described_class.new }

          it "uses the default logger" do
            expect(subject.logger).to eq Octave.logger
          end
        end
      end

      describe "#call" do
        let(:stringio)   { StringIO.new }
        let(:dispatcher) { described_class.new(::Logger.new(stringio)) }

        subject do
          payload = instance_double(Payload, name: "metric", duration: 100)
          dispatcher.call(payload)
        end

        it "logs the name and duration" do
          subject
          expect(stringio.string).to include "metric took 100ms"
        end
      end
    end
  end
end
