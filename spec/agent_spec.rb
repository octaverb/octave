require "spec_helper"

module Octave
  RSpec.describe Agent do
    let(:agent) { Agent.new }

    after { Octave.reset_config }

    describe ".new" do
      subject { agent }

      it "creates a queue" do
        expect(SizedQueue).to receive(:new).with(Octave.config.max_queue)

        subject
      end

      it "does not run on initialization" do
        expect(subject.running?).to be_falsey
      end
    end

    describe "#dispatch" do
      it "pushes the method to the queue" do
        queue = instance_double(SizedQueue)
        payload = instance_double(Payload)

        allow(agent).to receive(:queue).and_return(queue)
        expect(queue).to receive(:push).with(payload)

        agent.dispatch(payload)
      end
    end

    describe "#start" do
      subject { agent.start }

      after { agent.stop }

      context "agent is enabled" do
        before { Octave.config.enabled = true }

        it "creates the background worker thread" do
          expect(Thread).to receive(:new).and_call_original
          subject
        end

        it "is running" do
          subject
          expect(agent.running?).to be_truthy
        end
      end

      context "agent is disabled" do
        before { Octave.config.enabled = false }

        it "sends a warning to the logger" do
          io = StringIO.new
          Octave.config.logger = Logger.new(io)

          subject

          expect(io.string).to include "WARN -- : Octave agent is disabled. Metrics will not be reported."
        end

        it "is not running" do
          subject
          expect(agent.running?).to be_falsey
        end
      end
    end

    describe "#run" do
      let(:dispatcher) { instance_double(Dispatcher::Base) }

      subject { agent.run }

      before { Octave.config.dispatchers = [dispatcher] }

      it "sends the payload to the dispatchers" do
        payload = instance_double(Payload)

        agent.dispatch(payload)

        expect(dispatcher).to receive(:call).with(payload)

        subject
      end
    end

    describe "#stop" do
      subject { agent.stop }

      before { Octave.config.enabled = true }

      it "closes the queue" do
        queue = instance_double(SizedQueue)
        allow(SizedQueue).to receive(:new) { queue }

        agent.start

        expect(queue).to receive(:close)

        subject
      end

      it "exits the thread" do
        thread = instance_double(Thread)
        allow(Thread).to receive(:new).and_return(thread)

        agent.start

        expect(thread).to receive(:exit)

        subject
      end

      it "is no longer running" do
        agent.start
        subject

        expect(agent.running?).to be_falsey
      end

      it "closes each dispatcher" do
        dispatcher = instance_double(Dispatcher::Base)
        Octave.config.dispatchers = [dispatcher]

        agent.start

        expect(dispatcher).to receive(:close)

        subject
      end
    end
  end
end