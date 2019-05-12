RSpec.describe Octave do
  after(:each) { Octave.reset_config }

  describe ".config" do
    subject { Octave.config }

    it "returns the default config" do
      config = double("config")

      allow(Octave::Configuration).to receive(:new).and_return(config)

      expect(subject).to eq config
    end

    it "returns the defined config" do
      config = double("config")
      Octave.config = config

      expect(subject).to eq config
    end
  end

  describe ".reset_config" do
    it "resets the config" do
      config = double("old_config")
      Octave.config = config
      Octave.reset_config

      expect(Octave.config).to_not eq config
    end
  end

  it "has a version number" do
    expect(Octave::VERSION).not_to be nil
  end
end
