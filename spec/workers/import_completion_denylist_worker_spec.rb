RSpec.describe ImportCompletionDenylistWorker do
  describe "#perform" do
    let(:entries) { [double("entry1"), double("entry2")] }
    let(:client) { instance_double(DiscoveryEngine::CompletionDenylistClient, import: true) }

    before do
      allow(DiscoveryEngine::CompletionDenylistClient).to receive(:new).and_return(client)
      allow(CompletionDenylistEntry).to receive(:all).and_return(entries)
      allow(CompletionDenylistEntry).to receive(:with_advisory_lock).and_yield
    end

    it "acquires a lock" do
      subject.perform

      expect(CompletionDenylistEntry).to have_received(:with_advisory_lock)
    end

    it "syncs all denylist entries to Discovery Engine using the client" do
      subject.perform

      expect(client).to have_received(:import).with(entries)
    end
  end
end
