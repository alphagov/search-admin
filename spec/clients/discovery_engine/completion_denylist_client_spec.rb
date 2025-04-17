RSpec.describe DiscoveryEngine::CompletionDenylistClient do
  let(:completion_denylist_entry) do
    instance_double(
      CompletionDenylistEntry,
      to_discovery_engine_completion_denylist_entry: { foo: "bar" },
    )
  end

  let(:discovery_engine_client) do
    instance_double(
      Google::Cloud::DiscoveryEngine::V1::CompletionService::Client,
      import_suggestion_deny_list_entries: operation,
      purge_suggestion_deny_list_entries: operation,
    )
  end

  let(:operation) { double(wait_until_done!: true) }
  let(:response) { double(error?: error, results: results) }

  before do
    allow(Google::Cloud::DiscoveryEngine)
      .to receive(:completion_service)
      .and_return(discovery_engine_client)

    allow(operation).to receive(:wait_until_done!).and_yield(response)
  end

  describe "#import" do
    let(:error) { false }
    let(:results) { double(message: "OK", imported_entries_count: 1, failed_entries_count: 0) }

    it "imports the denylist entries into Discovery Engine" do
      expect(discovery_engine_client).to receive(:import_suggestion_deny_list_entries).with(
        inline_source: {
          entries: [{ foo: "bar" }],
        },
        parent: DataStore.default.name,
      )

      subject.import([completion_denylist_entry])
    end

    context "when some entries fail to import" do
      let(:results) { double(message: "Meh", imported_entries_count: 1, failed_entries_count: 1) }

      it "raises an error" do
        expect { subject.import([completion_denylist_entry]) }
          .to raise_error(RuntimeError, "1 entries imported, but 1 failed")
      end
    end

    context "when the operation fails entirely" do
      let(:error) { true }
      let(:results) { double(message: "Uh oh") }

      it "raises an error" do
        expect { subject.import([completion_denylist_entry]) }
          .to raise_error(RuntimeError, "Uh oh")
      end
    end
  end

  describe "#purge" do
    let(:error) { false }
    let(:results) { double(message: "OK", purge_count: 1) }

    it "purges the denylist entries from Discovery Engine" do
      expect(discovery_engine_client).to receive(:purge_suggestion_deny_list_entries).with(
        parent: DataStore.default.name,
      )

      subject.purge
    end

    context "when the operation fails" do
      let(:error) { true }
      let(:results) { double(message: "Uh oh") }

      it "raises an error" do
        expect { subject.purge }
          .to raise_error(RuntimeError, "Uh oh")
      end
    end
  end
end
