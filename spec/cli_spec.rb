require "spec_helper"
require "sublayer/cli"

RSpec.describe Sublayer::CLI do
  let(:cli) { described_class.new }
  let(:prompt) { instance_double(TTY::Prompt) }

  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
    allow(prompt).to receive(:ask).and_return("test_project")
    allow(prompt).to receive(:select).and_return("CLI", "OpenAI")
    allow(prompt).to receive(:yes?).and_return(false)
  end

  describe "#run" do
    it "creates a new project when given the 'new' command" do
      expect(cli).to receive(:create_new_project).with("test_project")
      cli.run(["new", "test_project"])
    end

    it "displays help when given the 'help' command" do
      expect { cli.run(["help"]) }.to output(/Usage: sublayer/).to_stdout
    end

    it "displays help when given no command" do
      expect { cli.run([]) }.to output(/Usage: sublayer/).to_stdout
    end

    it "displays an error for unknown commands" do
      expect { cli.run(["unknown"]) }.to output(/Unknown command: unknown/).to_stdout
    end

    describe "#create_new_project" do
      it "creates a new project with the given name" do
        expect(FileUtils).to receive(:mkdir_p).twice
        expect(FileUtils).to receive(:cp_r)
        expect(TTY::File).to receive(:create_file)
        expect(cli).to receive(:replace_placeholders)
        expect(cli).to receive(:finalize_project)

        cli.send(:create_new_project, "test_project")
      end
    end
  end
end
