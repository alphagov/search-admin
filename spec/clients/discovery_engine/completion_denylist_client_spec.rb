RSpec.describe DiscoveryEngine::CompletionDenylistClient, type: :client do
  let(:discovery_engine_client) do
    instance_double(
      Google::Cloud::DiscoveryEngine::V1::CompletionService::Client,
      import_suggestion_deny_list_entries: operation,
    )
  end
  let(:operation) { double("operation", wait_until_done!: true, error?: error, results:) }
  let(:error) { false }

  before do
    allow(Google::Cloud::DiscoveryEngine)
      .to receive(:completion_service).and_return(discovery_engine_client)
  end

  describe "#import" do
    let(:completion_denylist_entries) { [entry] }
    let(:entry) do
      instance_double(
        CompletionDenylistEntry,
        to_discovery_engine_completion_denylist_entry: { foo: "bar" },
      )
    end
    let(:results) { double("results", failed_entries_count: 0, imported_entries_count: 42) }

    it "imports the denylist entries to Discovery Engine" do
      subject.import(completion_denylist_entries)

      expect(discovery_engine_client).to have_received(:import_suggestion_deny_list_entries).with(
        inline_source: {
          entries: [{ foo: "bar" }],
        },
        parent: DataStore.default.name,
      )
    end

    it "waits for the operation to complete" do
      subject.import(completion_denylist_entries)

      expect(operation).to have_received(:wait_until_done!)
    end

    context "when the import fails outright" do
      let(:error) { true }
      let(:results) { double("results", message: "Import failed") }

      it "raises an error" do
        expect { subject.import(completion_denylist_entries) }
          .to raise_error("Import failed")
      end
    end

    context "when some entries fail to import" do
      let(:results) { double("results", failed_entries_count: 19, imported_entries_count: 89) }

      it "raises an error" do
        expect { subject.import(completion_denylist_entries) }
          .to raise_error("Failed to import 19 entries to completion denylist (89 succeeded)")
      end
    end
  end
end
