require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters do
  describe ".create" do
    context "with a built in adapter" do
      context "when given a string for a name" do
        it "creates the adapter successfully" do
          adapter = described_class.create(
            type: :single_string,
            name: "test_adapter",
            description: "a test adapter"
          )

          expect(adapter).to be_a(Sublayer::Components::OutputAdapters::SingleString)
          expect(adapter.name).to eq("test_adapter")
        end
      end

      context "when given a symbol for a name" do
        it "creates the adapter successfully" do
          adapter = described_class.create(
            type: :single_string,
            name: :test_adapter,
            description: "a test adapter"
          )

          expect(adapter).to be_a(Sublayer::Components::OutputAdapters::SingleString)
          expect(adapter.name).to eq("test_adapter")
        end
      end
    end

    context "with a custom adapter class" do
      class CustomAdapter
        attr_reader :name, :description

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
        end
      end

      context "when class is passed as a constant" do
        context "when given a string for a name" do
          it "creates the adapter successfully" do
            adapter = described_class.create(
              class: CustomAdapter,
              name: "custom_adapter",
              description: "a custom adapter"
            )

            expect(adapter).to be_a(CustomAdapter)
            expect(adapter.name).to eq("custom_adapter")
          end
        end

        context "when given a symbol for a name" do
          it "creates the adapter successfully" do
            adapter = described_class.create(
              class: CustomAdapter,
              name: :custom_adapter,
              description: "a custom adapter"
            )

            expect(adapter).to be_a(CustomAdapter)
            expect(adapter.name).to eq("custom_adapter")
          end
        end
      end

      context "when class is passed as a string" do
        context "when given a string for a name" do
          it "creates the adapter successfully" do
            adapter = described_class.create(
              class: "CustomAdapter",
              name: "custom_adapter",
              description: "a custom adapter"
            )

            expect(adapter).to be_a(CustomAdapter)
            expect(adapter.name).to eq("custom_adapter")
          end
        end

        context "when given a symbol for a name" do
          it "creates the adapter successfully" do
            adapter = described_class.create(
              class: "CustomAdapter",
              name: :custom_adapter,
              description: "a custom adapter"
            )

            expect(adapter).to be_a(CustomAdapter)
            expect(adapter.name).to eq("custom_adapter")
          end
        end
      end
    end

    context "error handling" do
      it "raises an error when neeither type nor class is specified" do
        expect {
          described_class.create(
            name: "error_adapter",
            description: "This should fail"
          )
        }.to raise_error(RuntimeError, "Output adapter must be specified with :class or :type")
      end

      it "raises an error for invalid class option" do
        expect {
          described_class.create(
            class: 42,
            name: "error_adapter",
            description: "This should fail"
          )
        }.to raise_error(RuntimeError, "Invalid :class option")
      end
    end
  end
end
