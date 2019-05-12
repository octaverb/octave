require "spec_helper"

module Octave
  RSpec.describe Payload do
    let(:payload) { Payload.new("name", app: "ruby") }

    describe ".new" do
      subject { payload }

      it "sets the name" do
        expect(subject.name).to eq "name"
      end

      it "sets the options" do
        expect(subject.options).to eq(app: "ruby")
      end
    end

    describe "#done" do
      subject { payload.done }

      it "sets the end_time" do
        subject
        expect(payload.end_time).to be_a(Time)
      end
    end

    describe "#duration" do
      subject { payload.duration }

      it "returns the difference of start_time and end_time in ms" do
        time = Time.now

        allow(payload).to receive(:start_time).and_return(time)
        allow(payload).to receive(:end_time).and_return(time + 1)

        expect(subject).to eq 1000.0
      end

      it "returns nil if no end_time is present" do
        allow(payload).to receive(:end_time).and_return(nil)

        expect(subject).to be_nil
      end
    end
  end
end